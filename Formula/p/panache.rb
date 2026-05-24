class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v2.48.0.tar.gz"
  sha256 "0bb4e3533cafff840202f89ecd282b9159f2fb8b68dcc91f851a0cbad301b27d"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e91d5cace3c0c587143766f13af089c0ed6af1508b2218928f96df8d1ac72171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "049dcfabdb5468ba3cba77b87d8e2b15e3fe1e065237045185ed5eafec08253a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6b7b39ea64c006f0ae3088c090f135681f2a21889b206c0da741b553e8b475"
    sha256 cellar: :any_skip_relocation, sonoma:        "19ef435059e74457a9d357eee1a6cbe14dce1ed9dd014a353d6fd4a91e2cb757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fdf37bc96177865f2dbf6585b00fd9af0f2ee5550233dab63edd222014a428f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5e4efc55824ca6c3764bb932ab81a2f2e18c211b4bb83c4dcc67f30aea5c83"
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