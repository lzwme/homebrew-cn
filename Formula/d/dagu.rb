class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "1e0d5abfe09ee6a56a2dac7f8880cce8b9efc0cc8265fdc8117764e5b3be6606"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc19c209d804712420a83a20f583795785092d2f717895d871ec30099dc1fb18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "490c4f40f27946f67af807f64008c052a03086b8489e50ea3e6a3c5ded6aed38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "187be862828fb0b537f205c2acc0e9fad91cfdb85a29398237b884907a014704"
    sha256 cellar: :any_skip_relocation, sonoma:        "25109a56eb1b23de99585fd48407f13ca96d9e072d0df8b5b815089580b159e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e82e58fa89730def8ea747d85f87feee9efde4256a3352ab9f96ab7536d94a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e35cacfd792e83ab9dacd798d323c511978742bffa990a057a9aab192ecec5c6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
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