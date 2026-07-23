class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghfast.top/https://github.com/jgm/pandoc/archive/refs/tags/3.10.tar.gz"
  sha256 "fc82815542c29802d087c25e2c1421146030806b71255ec40fc0e828fe1df877"
  license "GPL-2.0-or-later"
  compatibility_version 4
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "31cb9bed5f6711bb2da72a226ced9f78b887b7aa491316ee2c479fb9db9ccef2"
    sha256 cellar: :any, arm64_sequoia: "fe650d99cf619285f5a4c0b013a8f484b87924b1d10e24f728b47e26443bd4cb"
    sha256 cellar: :any, arm64_sonoma:  "60064bfb31ae7ae3e1aa6ad136c026dbb14ccd78e739a4aab5a4acf4fa90b1d4"
    sha256 cellar: :any, sonoma:        "9d972f15c437022896f6f4b084d75e2086867c766c2df1efcbcab1d051cacd26"
    sha256 cellar: :any, arm64_linux:   "3fd69ae7ac3904162e0b3c78700f1ea3559e07615efcac1c113e9e01adeb2137"
    sha256 cellar: :any, x86_64_linux:  "26f9bbdbc8aec6f2d729043f290c8a972d4b7ec3f1245e146d7280c9a74e5d2a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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