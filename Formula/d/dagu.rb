class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "b01c59ecbf8934122f1730b1da482dfef4130b9ca4b6a28f573a2a4117f7de4f"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "347455de6e35022f73482b5ac8f28074140fddf18e94351a4a411332d84417af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58d2c371e3c8266b767dab1c170139ca32e18c5eb17e41321b2921f779566e73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80b327f7aced485e76c8043f4b53dcf1f1aa20a5c1c953a3472a9972e718ba38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dba6fd3e81e96dea742e63334ddc4a0e62dd95b3aba57e5291f0325b9ff4872"
    sha256 cellar: :any,                 x86_64_linux:  "b9976eb0d2fe1b385b782ca69fe2e4ab889dc81f7a8a9c1dce2062a79dc52d8f"
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