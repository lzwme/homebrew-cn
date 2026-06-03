class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v2.51.0.tar.gz"
  sha256 "b8771e7e723bf9503fe07b398e6a6f18ab6191665eda96f3e5b11966495c6691"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c770036975c99c195f1b242e2a2054dfc507c200a286b83261d0b0af5a2141b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26c3c43fe8f9924cd5410bc792d336c5a5493339230bb1ff182f122834f95c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d780d8f05049e011f833f0c7ff2853b873bed64a4a61f9f2e42ccc0e4112e7b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc9a3a6db04e2827ff1b17e0868b0c1166780f84fc7f7a669132dd927a8daad3"
    sha256 cellar: :any,                 arm64_linux:   "036412a04f46e962ca6775158c73cf38575d26ca008f5e00a8d68fb3254810bc"
    sha256 cellar: :any,                 x86_64_linux:  "725cb9a5977a7fc5a7cee29ef4b782d852435b0bd4e112bcad7e6b2bc80addbd"
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