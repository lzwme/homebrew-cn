class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "00c4e0b630cc4603d4fe70b07f736511270ffb72e3a137223b3096b4f0267513"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdf3fbc506f5123584ea6acefc7a5f4ff976bff2d9d8a6644264230bda39f440"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acb12df870d57844cf89d284eda18eb72248b1fbee63fb80c84d81e625c2b856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c770812ebd3bb66049270698045e5c6182700083de5307dcae954caf38f398f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff2a09ccfefa85304433927ecc76063707be0c8b8c15c7df0241985f5331ccfb"
    sha256 cellar: :any,                 arm64_linux:   "0a858da0183404875a519711bc1b1b370829b52dd1a41bcfd8468ae2a6438e5c"
    sha256 cellar: :any,                 x86_64_linux:  "9b8931aab939cbc880c8e3c67579f638e4b9a249ba74b74245d1080de876006c"
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