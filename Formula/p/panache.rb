class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "501b7876c1c9376d7137071a88b88ba2fd129d246196bd806707ceb978bb3e8c"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd7fed78ff46c2a1d6d5fcf2c51d76a48c23578b41648aeae64dad2b33efa713"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3bc4d604007388fa9b4d4aa7897935ca50ad23756b72f8b966e1e97119343228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d3f0b1426a547eca4603c8c4b3db1bc50999504a3bd0e9a1784059524789134"
    sha256 cellar: :any,                 arm64_linux:       "3849baa132fcca72d639a8dff23430987049f50a28dd28c341ec2730d3ce76a8"
    sha256 cellar: :any,                 x86_64_linux:      "3406326ec93f9dab18c2b4c15c7e20bd5635f777bb85f8538008017497d93db0"
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