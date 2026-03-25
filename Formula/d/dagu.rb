class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://ghfast.top/https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "b907912df9fcb0ce3d2ec5e618518d416bee5db8abae5644e9a7ef84e3fe2e6e"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b8926b1b76803aad07f9383eeb8f9dec7afe1cfc1b5e342d03cdacf24b600a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3366cbdcd2f294abc58548026326a43423b870d8f6f56302cceff2905d085d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a38af643c6d9ebf0e301d449f386235266ffb6dd2e661d69e2424c215bdfc833"
    sha256 cellar: :any_skip_relocation, sonoma:        "faccee20d6200644981cf39a944e342e94d3589a1e4e318a595bb91fa6f3ad32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad97f75447a0745031dba3611744b1b0c04064a46048121df685cdf8d1e3079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6d26e33a10b27d3d7d49efec0f79ad3cfc166486553c0e5492100e479647b80"
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