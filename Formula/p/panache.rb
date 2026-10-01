class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "65b5b9da0ea2f7cf04e38e003102683bcaeca97e4c5df5dc4f77eda5fd7568b5"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "692f3f3fe53ec08d477b944f1c006f36c63b0460a74b47b24736348d1073af2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5486e79ff5904dcedf02b71eb7f6d17354d003a7491eae0c801fb0fb8e271079"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7348bcd795a238ae6ba0e43b207668dc534d31106f7a82661f39367e8b0bfb54"
    sha256 cellar: :any,                 arm64_linux:       "fbe7a99ff57e97f9bf54cd9e74de0e87299e7b0a11cd28f2ddd88dd45f4943bb"
    sha256 cellar: :any,                 x86_64_linux:      "21ab43c265eb2e361187ca3eab61bcbdd7da2542f16564a31595e1c575a28829"
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