class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v2.50.0.tar.gz"
  sha256 "c93739a78cb59fb0c91b7b3c52392a68768188474134807418dbc989e90b2533"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93020fef758778a24fabf65b19963510e477614438669d767c1569843bc88ecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e6d77e1c25d71e8e1bfe2701c005658804d1664809d3d7c1e4e42f8a43d9645"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a793f275388096aa5cb8a8eb1487096dbe64196d318c0f6afb9e31635645f3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b99db59dd2cd9daeae1f4ed67831e9531cacc3417b184cd496c315991bfdc0ce"
    sha256 cellar: :any,                 arm64_linux:   "4a6bf11d230950ebc373acf592845d448f4d1deafe3354f806a884b286553d9b"
    sha256 cellar: :any,                 x86_64_linux:  "fca3601cdf431eb8f0ef528be200ee991baf03f748d5612dd519a0014516ba0c"
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