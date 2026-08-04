class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "e518a5c60ebe025baae423e15b488461ad19ccf001f0b363eb8abaaa126ad390"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdf4e5047370648d4d15ee65ff5a9fd6bf4eb99cdcff33b29947891839697007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ddb9c79bc867a55b06bbd18dcf5499d82384e0a13a13db3ec7be7bf92ad225a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32e9ae3324e73cdb123e75bc738483bda4daff32801a7994285817e465e462d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a071001b97f9a2ecc05a30fec4a635e8f3c8a1e4f22447b6acd9e1ce54afdc5c"
    sha256 cellar: :any,                 arm64_linux:   "bccef1aa5dcfb5affa37681b3e9eb60dcd657ef4c8632fc506114257f40577b0"
    sha256 cellar: :any,                 x86_64_linux:  "3afa1bd175409e90f5fa9a3f4c0d8b43ba1cb0997b5f5d5eb20cc50de593618c"
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