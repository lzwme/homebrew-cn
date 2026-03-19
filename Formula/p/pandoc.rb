class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghfast.top/https://github.com/jgm/pandoc/archive/refs/tags/3.9.0.1.tar.gz"
  sha256 "0a5207bf78c5e49e39245b53c3d8eeb72e80202f21ad0b5ce2c3635ec65f6f98"
  license "GPL-2.0-or-later"
  compatibility_version 2
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "689335cf0854cac6a8d833c61f003f034672522f69b358e66fad00079fa71862"
    sha256 cellar: :any,                 arm64_sequoia: "5dec83486c6a203c9f676c3e26e3fcb50ef250b9aaafa9605e511445f0d837e4"
    sha256 cellar: :any,                 arm64_sonoma:  "022463f484ded92effdc572746e3b4bb68bdd8c7e6e146202573134f3902331a"
    sha256 cellar: :any,                 sonoma:        "c8e0f3db74cd0a4c01742432f2b8595ba4deadeac5177363bf8f8e542dba8bc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4b5cedfd1d3ecd10d136f30259468e91848c609e3b64842006487792f1d58a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b7676fb8827e58b5b0d9a7110f667a29bfc61e7096e7942dd0121fea58a59df"
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