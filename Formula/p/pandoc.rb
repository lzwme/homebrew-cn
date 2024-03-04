class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https:pandoc.org"
  url "https:github.comjgmpandocarchiverefstags3.1.12.2.tar.gz"
  sha256 "f22f18fe008641fd3fccddb040c3747efd57fad669df6ca41f4926421f317bd2"
  license "GPL-2.0-or-later"
  head "https:github.comjgmpandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ee94f492dea38f6415b9b4b375ceae017165c6fc096b92f5e06e75e79ccd99e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9daf2ae6831c5863d818a8ca82894b3e0d5ec942d6e9a9f966afc8d94dd9743a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a53db00eca687eba7404b4427b7b9d1a2aa9e4863bb00fa93cbf025e3d66a4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbc5ffaee5a9336df4adea7b2a715cf72b2325362573a1365c931fb999df55ae"
    sha256 cellar: :any_skip_relocation, ventura:        "4177c2b4730a29c5ceaafc9112a61b49ab4d6016b8f9cd98e4bfa4061460216a"
    sha256 cellar: :any_skip_relocation, monterey:       "b2c7c9b1c77bc647a01f822ed6ffb035c1b7823d9388b45378b97f98adda156c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fcff32ade633237b8825241fe09269fdafe5bba240c59b04dae7dc59978fcf4"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

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
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew<h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.<p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}pandoc -f markdown -t html5", input_markdown)
  end
end