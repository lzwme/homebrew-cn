class Mdserve < Formula
  desc "Fast markdown preview server with live reload and theme support"
  homepage "https://github.com/jfernandez/mdserve"
  url "https://ghfast.top/https://github.com/jfernandez/mdserve/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "fe0054e756b21bec850c3d9fd66473661575ce58425c9a1422e3466b13654cea"
  license "MIT"
  head "https://github.com/jfernandez/mdserve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7428003175bc86f9a37c908683a5efccf846aab58eaecef64fb93ddc70fa409e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9da96a7c01a54437bd45e18dcb3bdca9b7d2bf263baa09ac2810dc31b37e3ece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a99334cac55dbe1eb4976c50c6c6576cd2067ba4b29ad899ebf68604332df31"
    sha256 cellar: :any_skip_relocation, sonoma:        "830c84c66e9b3415f2f78abfbd3aab1355aec1299e2a180717f2db2e1cb09a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bab127daef99cf916e2ff494a16d208cf4146de365a3e8738f5180041dfee67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29614d94f3302890b600e5aa27161ed81ccfbcce2e0dea07d3b7fdbf963ea3f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdserve --version")

    (testpath/"test.md").write("# Test\n\nThis is a test markdown file.")

    port = free_port
    pid = spawn bin/"mdserve", "--port", port.to_s, "test.md"

    sleep 1

    begin
      output = shell_output("curl -s http://localhost:#{port}")
      assert_match "This is a test markdown file", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end