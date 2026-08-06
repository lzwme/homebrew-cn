class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "c1a58bebaf929c78a5dade66554a0341818529c7e65ee235ac14586669163760"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40f07619f3270ff46224c0c0c28479c26d097c72e0ce9f9e448f9824fafb3cec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "575e1133a5f3f6496dec4021c976764c2efb638f3ff223bc0c50c2bceef35109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ac470618554c6858c55aa4b3ff70191381a91483da69a2253dfe93182a0cf02"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b24f3b93e081df7db508a9c99f017f192ad04b94a9bdfa9e0101d627b356272"
    sha256 cellar: :any,                 arm64_linux:   "dffdef2749803295ac7179ef6b38a5fba13b415123a2b1670522ca94a4cdd1aa"
    sha256 cellar: :any,                 x86_64_linux:  "cc4622d35933492f0f3aef9f48c79a846d7831288446daa9584284e4e0c39ef2"
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