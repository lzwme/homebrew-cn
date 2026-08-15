class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "15d3566a65e608b89bde0206028ef7217a2e949806aaf86a3b4e9404e7a8995e"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e66148699061c41a0f74c95d3d17292039738a9f682bfcb16c1ead463d0ac887"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbeee9983f383f310ca16a409159852f38b962139be06a2fd4c159af547ea83b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "476d9d9a6db528c6bfde2101f8b238b69241881f6a602442621e9d6aaf4deb99"
    sha256 cellar: :any_skip_relocation, sonoma:        "9add43809c6af404250417971df3294774ea91bdf7721b09c9bac35c7c99ad77"
    sha256 cellar: :any,                 arm64_linux:   "cee69d24bb2817c8a7f72704ea12f50abac591bc4d174e31654acf9cece2b376"
    sha256 cellar: :any,                 x86_64_linux:  "1ec5928aca596bbf5423296d9cb5d7da6e759b57896f8b744ac92b024d5eeccc"
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