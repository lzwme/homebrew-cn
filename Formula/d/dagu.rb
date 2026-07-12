class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.10.6.tar.gz"
  sha256 "12ae81ae1233a2635a9e1a69e969f31d759dd09f8519a09e2ebbb06dc80a6188"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "441e88c1f65c31549f66bbb40290972d31e34046490c875315a50c6cfea1b413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "148bc84f518cd9b089dbe43d7d37f95f3f91e124f565af0466147bbc2a059bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e76f9f7a8a57e7695005bf463c6c25852338d5868afbfce7e5796689ecbb9f30"
    sha256 cellar: :any_skip_relocation, sonoma:        "cadda29652860ba5a47c209c75d67976b70cc132b1351dee20b90b461fc3be06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31a2df662f42740fa7cf9beca62e778edf6b00848b01ad7a633ac769f3300fc2"
    sha256 cellar: :any,                 x86_64_linux:  "929a2d105bee44c7a9d0407fa0c0addaa0c73fe02d01f33e5fb9ac061b0a3735"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
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