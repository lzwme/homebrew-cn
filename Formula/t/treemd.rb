class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "e30ce75a7cfe0095302295b034553052e5b1e56af782d615f211fb59975c30d4"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eeacaec379e6ceb82684d90248b5db0a57d36c9ef99e9c12a5ef88b05dee6ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e567a0e3019974b45b6758f48e2af075af6a59763f0ca425f40889a6ddc09caf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f897688071cd9264522d4a41b52103ab52d890d641d01ff844109adb2316331"
    sha256 cellar: :any_skip_relocation, sonoma:        "2baf8d9d41cc8977eb5f2aa5bd1c72462810d80e0f9b57bddaba9123078072ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f35bbb6b2ecd059cd67781f4ce60775902b4629d393497e03572f32be4181ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dac7c2325ded14f2bb3f4172084a9ebbd7a18920dd6238a72108187f1f91ee7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end