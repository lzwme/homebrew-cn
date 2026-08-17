class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "ba847f9548e5b327559e269e7caf2ad5ce10a758e05134e363c5328648b8a734"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef4c77a98f085f726f43ad38e3ae9c560e60ef266e9cedc43722e4302efa506d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de4095c6ef9b95497659cf539a8cb5010cb7acdd76122e99139b03a1e3b358c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a86d50a6b232771459b8616e60f6ce77b609095ae1d87d3da0e61fab72381fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fc9247ac14a6825c6f1780626090d7fd6ee13e00a8bded83c7309fb5ccbe11f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cc852bcd7f147487cebe9f17a1c2d928b7f716ce3308e42d5194f2e326d23e9"
    sha256 cellar: :any,                 x86_64_linux:  "b00c5549ba5dbee28778eb0f66d9ab5c38ce0ca45ca3e5f8d36205397369fb14"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "Result: Succeeded", shell_output
  end
end