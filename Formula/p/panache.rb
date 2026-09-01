class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "3658e9453b9452657943dc4557ef400e2733451e5b9acb89be9bbbcb65f48e7d"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eb859a98dee211a9e28f8bdc2b70f853d041a574e9ebf48c2a886d37aa0693e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41576485da68d677ee426ff3ca44ec622f67ae8deba83564949521a3befa181b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a040142d8df0e7631624bc45dfed72a850edb30cc8069a2aea418bcd5c93e428"
    sha256 cellar: :any,                 arm64_linux:   "fd762245b7725c558802b762602da1e0974188074530d345e695f0c71e7db639"
    sha256 cellar: :any,                 x86_64_linux:  "cf87eb911069a79fe6e2566d9232c64dcd7e377e9e7d66c706e46894ee6e7111"
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