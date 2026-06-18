class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v2.56.0.tar.gz"
  sha256 "50dd73f1ef4d7e8afd9ce33708b2958bd2474305b375c42ca28889ab2d26f420"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29ff3bc357412fac5a50fb2829ee123ea2868294d03c116e9c8100a2bb28424a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8531ab306760a2e08d2860b84a9362c6db536fc8cf8f1d0db6bc894097192fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d66269c1daa5914578d093625101a798d0e2bc4efcd50fbee523ce8b76d3d58"
    sha256 cellar: :any_skip_relocation, sonoma:        "f98a54840f9a46161e0342a6e5d5664326d7314e435015742628d9e922ad28d2"
    sha256 cellar: :any,                 arm64_linux:   "a62e5fa3a719b45ed48060b6fc423cffa0df73c52e6fe1bde2ab72974d07b213"
    sha256 cellar: :any,                 x86_64_linux:  "7503d46b07dd707fa5b9d8dfb2670adfdcb5b0e505b0320a82abed917a3be957"
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