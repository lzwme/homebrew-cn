class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v2.60.0.tar.gz"
  sha256 "2d5d01c6793feee7d6abc081dc22c076ecd4591bf68e677f5ba8728469a2323c"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b34ea9f871df8ae2c7158952bfc9953dd991b459e43dbcd473dd63edf206a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "538d954bc16e0477d872b235cdaf840c27608abcaaac393c4dcd2b60f671750c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b384e8d1b27fbd6fd30eabbf2af40002b6f6f54078ac1143a7654661bf572227"
    sha256 cellar: :any_skip_relocation, sonoma:        "d909e4bf6083c1333946c0617ca938bc2189ed06fa3369441dffcd38b0601f2f"
    sha256 cellar: :any,                 arm64_linux:   "c310cc57dc09fe6d58ab5982d7e24bccbad15663c05651caf4ac92176ca0de5e"
    sha256 cellar: :any,                 x86_64_linux:  "442153ce8833429918afc6a1304c4e4dedeb4106c98831be6da0e01ff481a58a"
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