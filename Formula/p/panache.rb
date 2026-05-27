class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v2.49.0.tar.gz"
  sha256 "0857b3889788bae979867d4e15dff3489a27b12f92e7d94224826f7844091a4b"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8031569016aad1b62aad9fc035b9c63e023921926711870a4ac8874fb81331f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31f4a780c24d797b4a712759c8b97a4d1531ac0a061349f6d6046a21a5e55105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "912880d1a1ce832e9ff6beaabab117b8beaede7ae49e04c9dd56930cf030b2a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1895c09d97f26a70df6161e63cf9442359072176150ba1192e1824f6c8e70d78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0f4abf8a48a468278bb02703fe64d2fededa08613c4fbdd34275d0c2befb788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b931a8ec26702070576225949e664471e9e9c6caded047025eb8feb89396c58"
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