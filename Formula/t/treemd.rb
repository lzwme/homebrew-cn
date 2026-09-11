class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6fb0a35897368bfe5c40c0d44cc872c18c51337697df27fda102cd1cf0d3ee37"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e69fd1d1db03a63f24af632165bb44a8f956939338e59c0822ae18e304f8fea3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbfa7a7dd2c24a9bac9361c24d8128148960308ab4a18dbe623f227811221aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47835940c2f4de6dae221cb3ecb2f0417bd7c41f8ff0f9b399059d0bea98206e"
    sha256 cellar: :any,                 arm64_linux:   "5420b4b0f527320254bab774591c4dd169f19bc6fc811682662777529255a724"
    sha256 cellar: :any,                 x86_64_linux:  "8cd0d04af16d0de4176265fa7075ed1d32f9eedaa95a8ed8f37194d5e7a153ef"
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