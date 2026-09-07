class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "e942f8e1405c7f09f1311d04095717c3bf0842e6f407208e631f19f6b79b9a0c"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4eb15bf573989524c18a834dbc39cced6237bf75eefb77a55d5a0016ac39edd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92994c30cab9ce6370e5f34a23525cb38b8b882a05cefc646afe2e10c38bb184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7bd4ddc4d3cb8ba57afb4572530ce84c859f53d02b1f5639240d268db1bfc68"
    sha256 cellar: :any,                 arm64_linux:   "7136faeb5bf1fee08dbedabb78859df877e691b0250dd5e1dc6a3651b6c67c08"
    sha256 cellar: :any,                 x86_64_linux:  "288c431561b585f11747445a520a1e146da4f3871022814bd240ea605dafb4a3"
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