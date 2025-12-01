class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "247ce8c257403eacd54b47d90dac8e05f126674569a6d63984ae11aab43048f4"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "538908afa6333704d8f582cdd16a814539feb5e2a4e24beb479337cfec295dab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d214a4e036c799ef7cf3987de755c12a3db6828a0aa8ee763a39b7854ce72033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bb9c58fc6d358b4a6fcb2a9e4954b6bc4431eb1a6be56e02935b0909ab677f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1c33d591bf8d0fd8dc94d04ee7314f615d6799d19f37f4ae585bc3ae3a49a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b67815cd1c443fe6e3a352c565a8f0b660a4d99aed1837db10a2bf9b67a2c4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c28ce5d956ad742173d963a5448c2d06e75baee0d110d7b08a7ffadf06fb5ba"
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