class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "0892563b134dc4a5cad99f017cc14dc22df2bdca2d5bce80507df8558d957fbc"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b68b3f8f34d3ddef85945923eb85e18075526ced4164691d8e1d8d2ec0e55271"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "295b8e8a237b584fb5c6c4e0467c7196b48717d2caed95adf97fd492493b75e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "080c8fecdd5b3156f224f2aa43c5c9a1d86e990be384ffc2ea87d914623c58c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "67d4327576c15e54df62b16272f3caf358b7ec564b1acbf3315efc1a50c332f7"
    sha256 cellar: :any,                 arm64_linux:   "e5a18fd0fe77f3218f09b37895c9b9ed62ab61a5f1d9f55c7e52d57fbbc4a0ae"
    sha256 cellar: :any,                 x86_64_linux:  "13159f907ee3d065cf5a09b8f07615a50d3e9a045003e2a5294bd552a5dd56ec"
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