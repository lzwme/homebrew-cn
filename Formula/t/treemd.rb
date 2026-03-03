class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "0c8754512438c29cfa10765e4eb2dbb372cbd40f16edf8aaa37a73643d9820f4"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "081786331613368dd5b5d51c4c8d1ed681b64698e2af762cc6a96fb0faa5b579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8064655629bab17efd9814a38844502d34c9d2903dbffb6886816a589756dbb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "642f9204ade7d0f753458bd41e29b718ba9048de18a2ff338bb2c6b84f89aa7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e8504ccdbb147b55a9491fc0dd50f566d1f7ed08626782f25d1875835949d1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ed9a5db8ee32ed39eab342af1522501c20ace0543ab019bc481dc8b3b329d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fbd91b1eb258642ac7559bb42f9d0d163a2adc2fa06809a6495546eb45b72c1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/treemd #{testpath}/test.md > #{output_log}")
        r.winsize = [80, 43]
      end
      sleep 3
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end