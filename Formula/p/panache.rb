class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "6f2fe2fba47313585d62ef2546a746c738757306fd2337f7022ce9e16eca5fbf"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1eec35ec34ec885a2b30bfb12164f15c0299911740fd4b9cef45b439d7d7dd30"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11777939b130974b2510f136711d50ef220e6c1b43c14bd7229b80ef83069981"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea20eefe73d64a649d8cb63a41df1b4b27daf8d742f4e14a55ab1e1f5f02bbb3"
    sha256 cellar: :any,                 arm64_linux:       "f283816f81d33c8f639d7e0c13912e26a4fc6ddc8b4ceddf9e359cc1e896ca1b"
    sha256 cellar: :any,                 x86_64_linux:      "c275c13fdc5f28a8c0829bac7e100050289c806384fca2b611acaf53da266e9f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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