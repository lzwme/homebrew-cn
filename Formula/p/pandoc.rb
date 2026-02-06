class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghfast.top/https://github.com/jgm/pandoc/archive/refs/tags/3.9.tar.gz"
  sha256 "d8da16e1ad1f685123fbc1a5a83b74766bcfd939dc6989484822f023bb70438f"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1aed4d054b3db8b8186ad4904beb55863b5dd5a57ee8b51c20a8f6012ec2b1ed"
    sha256 cellar: :any,                 arm64_sequoia: "353a2850aaaf438461132861ed32433c6f0173928b9a718eab71047e28e644b2"
    sha256 cellar: :any,                 arm64_sonoma:  "fa0bdb4fd7d17e0b774935d4a043d064e26cad3b342552d93a15a1ab4f75aaf0"
    sha256 cellar: :any,                 sonoma:        "40bd1c0e68f70923b315e683d996aa746c1a830e8e7f458e507e3e8c1164893e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "379073b7f7b7eb4ebda597cdac71899afeb5d667402e0122ba0b594875711052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4c567bb1280d9043526d941181a8c06edbc8cc32fec0168dd9cf3a1f70f20e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "pandoc-cli/man/pandoc.1"
  end

  test do
    input_markdown = <<~MARKDOWN
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    MARKDOWN
    expected_html = <<~HTML
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    HTML
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown, 0)
  end
end