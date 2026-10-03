class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "68a89fa8438e2caa2a64cda7219544529299959a15f74bce36c744319c48a618"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7075daa159df86f14d6eed28823ca0b1aebd8d7093701aebd94bbc3419e763ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "382b0058059ffa7c1ba24c91eb0b3e8659bfe7188537a586a0a6a8efacb0cba8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9b4a7f7aac4d4c1ad6676509bfc975e84d71446a8276fc7b3aacfe4d1cc032b"
    sha256 cellar: :any,                 arm64_linux:       "86f7d219a62d612441dc16d664f360cc546458cbd9dab0000a586a9356089195"
    sha256 cellar: :any,                 x86_64_linux:      "aed01786ec53deb801b56de7aced4e0a87d8eab42a202209bde39cf72bd9bffc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = <<~MARKDOWN
      # Heading

      * one
      * two
    MARKDOWN

    output = pipe_output("#{bin}/panache format -", input)
    assert_match "- one", output
    assert_match "- two", output
  end
end