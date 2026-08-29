class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "e72be7e60db97513e10cf4afa21008976433f49d4ead9876e15e1c7443285e29"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10181a0fc8412c70e189813d74bfbd5a5c8199b78c31ec08ccd78d638cfa8966"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6288c634f5ebfb3b4645469a9642f55281386efd57267178ee4eb157ea77364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "668e6e6db21b2b07a8c32c14ff1fe8ac149e0631cd6499b16fa808f729aaa263"
    sha256 cellar: :any,                 arm64_linux:   "1f7c6938058395ac08a4e17f5268572b6f1ed077cf32c69877d732a3e39a5bdd"
    sha256 cellar: :any,                 x86_64_linux:  "7ce29fea22e7da4ceb539282ed47c7bc1d06a5f0b376cd755975f774a5b23f7e"
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