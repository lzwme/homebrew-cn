class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https:pandoc.org"
  url "https:github.comjgmpandocarchiverefstags3.7.0.1.tar.gz"
  sha256 "f116324c77ce0aa16ed09d56557088260fb79137f19eea654c86fba06badb3ac"
  license "GPL-2.0-or-later"
  head "https:github.comjgmpandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aefd8fc4d1429823643ca51537d14350ded5097f3bd71cac81a4345cfec80182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42038fe5af304744d51493cd25ed292cdb59debad7da9479de6143fabba883be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2312f439d7d2965387651552f593c513caa7ebd1a738baedf297d7d71217419"
    sha256 cellar: :any_skip_relocation, sonoma:        "da397257bafc59682a2e22748229d057cef38fefab4cc9fce7fb4b4846cd45ec"
    sha256 cellar: :any_skip_relocation, ventura:       "da9ff27260b70529775bd43b8ed084e110a65ccb22308cea6380c896d9b589e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5944884e5f484b6d088eb8b8d435e948e624c07318b290e9ff24a0677feaed1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "009395a26c9b9f80998d02823f7cee768cac8b345726c0ac71a6e6fc664a0042"
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