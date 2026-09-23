class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "d525de4b609c1b8c0aee60fab31eeda09c10e95d414a56c178b82e5efce3719f"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f73080c678cc5cd0ce8030a4fb4fbd75ac334677853172b001a9c0d42bad57e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf3b0d3cd761a297a88b4cf92c69220179e52ba0c17e4e30556b1e1288f2cf45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "260f1c2f1f5bb69c0895895130ef1d9e4a3e2b58d2f227d49f85a53cae0e69a0"
    sha256 cellar: :any,                 arm64_linux:       "d91e83aeee052e926a36fd08b33a84f70eb41b73605b7c49a10205c7624e024a"
    sha256 cellar: :any,                 x86_64_linux:      "9893a9b0be7880ff6dcf9e59023c8c4aec26d40342629fe31be87e20dcec54e0"
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