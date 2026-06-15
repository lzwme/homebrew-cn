class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "f0f14dbb84636e2e27d14d4faa0c9dd421e36cd825d55df0b19d9a1e0d2ea46f"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a707eb983eb12da458b4e36f0e1a7ada3e69440f23cea4de8efd5c25bbf37f53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "326821f764b9b95ab89a2256684fc8452ad8dd1195919c3f9e2b7372b2deed4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e51295b1847948f891a577a05b5f885d019411b09bc3681bd6cf8780a6e0248"
    sha256 cellar: :any_skip_relocation, sonoma:        "d549227a33247c4415447f605a7559d11c6c3242bbf910e4473cf75d55a9c51d"
    sha256 cellar: :any,                 arm64_linux:   "cf69337dea589ec91d7855eb61b5ec4079de83d2dfc6735a25008463fdb2c1a4"
    sha256 cellar: :any,                 x86_64_linux:  "d8e54aac04b2b775744f675908e7ddc98c96c58cd91e43bc0efe1a9c0e6d6a01"
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