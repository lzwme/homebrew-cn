class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https:pandoc.org"
  url "https:github.comjgmpandocarchiverefstags3.6.1.tar.gz"
  sha256 "85e685ee8c8407ea40844145df3cbc1e8469e861dc3454f86dbfd23122aa27e6"
  license "GPL-2.0-or-later"
  head "https:github.comjgmpandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cbb4e2faa8250ae48bb49491ebfacb859be3ea358823565574dbb4abf26753e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1269e7acc3f99ede93bbd5afe59471437b3409c1e87b956f35d295808480f3af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "909f840a955ae3a0da53a16b3295964b86d8f00a6f53bab1ee8d132527c27bdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f285d09ecd8b5cededf7d3ee7c2a398c2314d79df9e28a60235c7de57621af65"
    sha256 cellar: :any_skip_relocation, ventura:       "cfbcfa05baadaa521d76d3b5f69c35267dc4875d313353d8a09f00f7f732bb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e2f9c98f06d73535aa3ad16d491ed515421fd9cbc41a3ebf85de503c92dcd41"
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