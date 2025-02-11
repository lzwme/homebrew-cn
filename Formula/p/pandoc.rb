class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https:pandoc.org"
  url "https:github.comjgmpandocarchiverefstags3.6.3.tar.gz"
  sha256 "5e5d78b79f86454cb542246d318682f26e0959e8f1aa068b3645832f8d5ed170"
  license "GPL-2.0-or-later"
  head "https:github.comjgmpandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a6ba097780a58e63cf6714efef40fbca646039f4b7845bedb31025e6a59861c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0681e327c205488bafe163c61170a6d4c215672bcd59cdeb90b0ae8baa3b566a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f76afd990901d6bb1d67c8d16205a1a42586b193f6caecd55e08c323a28ad3f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9de1ea9dc85019dcb400bcc5587982cfe7533e6992d154d269ecc2dedf44c424"
    sha256 cellar: :any_skip_relocation, ventura:       "3bc2042ca2277fb29fcb3602a2198fb2606d819da3faf1f2ec75db62cfd50747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0e1f7b9c16dfe58d23e67e4807a5c60909bd9916e5754a0b5cf6f793ddf6350"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "pandoc-climanpandoc.1"
  end

  test do
    input_markdown = <<~MARKDOWN
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    MARKDOWN
    expected_html = <<~HTML
      <h1 id="homebrew">Homebrew<h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.<p>
    HTML
    assert_equal expected_html, pipe_output("#{bin}pandoc -f markdown -t html5", input_markdown, 0)
  end
end