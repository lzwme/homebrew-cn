class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "728265d193e24c66067f57b6b270e104e7f03efcdc492784208dac0925a9bf67"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8564b86d4a7b15c17449b41f8cc759a84f5e22af294b74e38f8a53c19cae4481"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d0d1c89974db03f99543beea8e62378943f6b75bcb81ac340f253b15093654b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1b779b6b91a7baecf3feeb2a088aafd033f4b96160ce6b895fa0707b06d0487"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ddebd88a5ba0a02189e53394c934b6659899c99a7b7f660a8cab747031ef96f"
    sha256 cellar: :any,                 arm64_linux:   "b7878e3a71ce3c5a328d7b77356c44fc284800c0d8f163bef38f752785e048b4"
    sha256 cellar: :any,                 x86_64_linux:  "73ab9bd8a8b5eb02cd9ba8a39ee1c71f3618f4ea7e734ad905c3c7f9f5ec59be"
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