class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "5d372aa023b090fa57fe3a4278907e890e69b6bdac48e84c7c86dd3eee4ba4a6"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7150db185b0b2352e7676da2bbe40ba04531c027ea0e0e270200766961421411"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "158ef03568ff4114dc5e290e605ac5dc40967881413dc18b5462a1b4cd28a464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e17a5ce5d31731ad36107787a89eb18a209a11aeb47d06612ee377040f3e3fd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "989cbe733799f566636d6ba13f931c0a737a139bed4cc78b0f9625ca4d0dd26a"
    sha256 cellar: :any,                 arm64_linux:   "f739d3e212bd6f3ae12fe11f7660909379ebdcec22798564eb290f7d52e014d9"
    sha256 cellar: :any,                 x86_64_linux:  "1b5c77caf54d9d8dcf962a668d05b5181b82992ccdd2897598cedea72fd4f3a9"
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