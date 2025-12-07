class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://ghfast.top/https://github.com/Epistates/treemd/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "d696d7336eb7bcccc12b4599cc0e4917d71b0a318cd467f7c8c0e7fa93c11490"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "302336b618ade08705cc56e1575ef0799dc5ef9ab4912baa3e0d1b718fc8e496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3a08324dd7a2239a0d408fe43e9df39862fa4f006aa3fffda6b1cf0d3006af5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9725dbfaea76856505ea320d2d7c012bfd5d7059bc19288e0c333545ff6dce6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a71a8a2ea0d5f581c73a0bdf8ecc0ab4728671f0a7d1f629eb439fe041d2808e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7a2bc240c8930803697e991659a831a7d0189946a57bc9eb1612c46da7a7792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32cc6eb8e241ea03eaf535480efbd7b087b20ad1871ba19a036badd2c7470a18"
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