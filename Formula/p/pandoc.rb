class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https:pandoc.org"
  url "https:github.comjgmpandocarchiverefstags3.4.tar.gz"
  sha256 "7885c3aa2426142fb6b9d0157c2bf8484a6d560e62aac29bce51bf0b581ba259"
  license "GPL-2.0-or-later"
  head "https:github.comjgmpandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5361742fd224e74bcc8f81212f37c16d73d811356bca34b610a909cbe552416d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1957e9d0e51a39c1acc24ec1fc77e08c08726e7e1d789a5622e9f16087cc9821"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "faf838fa85317ea95542455926ceb5abce456d916994793ac9b211ef30959c25"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce1bb15b949afe09f4171fa7e189d16d2350da4779f7c41433b81b6d072b9c37"
    sha256 cellar: :any_skip_relocation, ventura:       "962132fce258830c9f3ad4c19d51b00a87e2d558ec965e35013ade28a368dad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3046105edd77d06ae0215ce9cc36d2576547cdc299ae820a869ca5d343d85224"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

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