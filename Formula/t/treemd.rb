class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "244b62bf235b2a75a166b9f0f11c53e655a54018c24fd5efded70a936dce58b8"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dbd03c61e69d488eece4db6fdf09b98fcaa459c21bc2fcc6a53feccc1a57b3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0377b352e3e0a2ebd6bebd604c142bb9245853951634a5c335ccdf29ec72e190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77772260d9d7c9139a89414feb9ec237ec3d957417caacfe19ff6e8e169abd79"
    sha256 cellar: :any_skip_relocation, sonoma:        "02b6edabfdb0931770df45603492e4fc40d05af2b80e86a0ba1d7566d3492194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acb899cb06a9dc9ddcdfbd9a5478e4a9380709a6d22145be95a698f394d85e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "833f33c344d856b5a091a141b5a01888a710c0c0394a27e1808e6338e2c1ffd2"
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