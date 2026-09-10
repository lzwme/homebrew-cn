class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagucloud/dagu/archive/refs/tags/v2.16.3.tar.gz"
  sha256 "4305df3ea1feb5bcc64fbdfc7251480a657ce253abbaa255839fb9420ce228be"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc7c1d7ac34f7eccd36d53de5c6edabe5a8c923b0c2baa93983b38cdd1681076"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d716aad8db3c7424c235a367d537a58228ceb436d7ba1f048a37f238cdf20bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a46b69f5d104c4d395c41edac71c3e2cbdfaf6ec05201ba63b47166f54f77f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eed6514abedac80db80b6c0856345df50aed7ee54c9d25c3785641d7cc46fe3f"
    sha256 cellar: :any,                 x86_64_linux:  "e31b5322e29bfce6ba59edf72c1d20ae9a66f9782ba4471854d76b3ddadce9ba"
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