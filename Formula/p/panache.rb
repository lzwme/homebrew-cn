class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "876958e4e89292a1456932c86ce9ec3e90831149d33c28ec6f13eda4f9409083"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ea42573486a9c15f76461ffafafb09ca3d0ca2f717965f9b45562c81d45180a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e79373848c58f77e1a1f29ef2533125f627566b77953a4a96815c5004a5e0b34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e33772067afdf9852aff7fba49056cb15f22e2c16b9f3904e769d3aa718e6ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8b96d680ba40385816bdb57a5d5bb21172ee66e692b273e988b5f6e1299ee20"
    sha256 cellar: :any,                 arm64_linux:   "a4bd25527d6701a3af3a7a36f4b4c378115fe1eaf449bf7f0238ea3bb0128569"
    sha256 cellar: :any,                 x86_64_linux:  "a5ce10b7ccdcbad42bde25d4ad2dfb4aa0bed49f9ddc2a698ddf03696e50c573"
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