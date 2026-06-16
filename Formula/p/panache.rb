class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v2.55.0.tar.gz"
  sha256 "193fe5b13b07387ac46aa1786ebe69211e373b723357e937d5913d02bd22ff81"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c8614ee21733c985bffee5bb9bbafcb5707cba2dad1a16e71a30e05bc46edff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbf0eebf6df56129682f5ce7c53f313cb6c3ca37f5ac8cc228a68e5ab1e1c456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbc7fc29d4642d57affebd56ffc6ba76e091990fc5928f004e1d6ea4588bb236"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed2157e8d42ca4931058edefe944c05a9b438cdd5c43ab45651e7bc0ec8d3da5"
    sha256 cellar: :any,                 arm64_linux:   "be863b99250d1f313197eab4a6e12802a1987b5debc2292398c165a7e4e71ded"
    sha256 cellar: :any,                 x86_64_linux:  "eb7ac434ca6fa49828c93d7b4f605e8b77eaa050ed52a785326fa738964f6167"
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