class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "ce8050993539083dab0a471c898cbef405d8795d0d2bdad6259a2e57802ddf6f"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d43ab0bbc8f6ccf4710038814a7449c48150cc3b4a73601dab7fbcb7f1b5073b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b58bf70f925ad4fb84669b55fe68ddedc8761964ef131a2e3af10ab6b8b7eda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e35b7ab6e027028a199c8d2623c53f6aabbfa2e31230c2f9581c30d1d7eff521"
    sha256 cellar: :any,                 arm64_linux:       "b13ae1881e4544e7993101151bd13a57300420e1f897524eab000f742a7ec332"
    sha256 cellar: :any,                 x86_64_linux:      "f174999ab81ae996fc1f0d306071eab2ffa9608db9005b00c50079265f7975e7"
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