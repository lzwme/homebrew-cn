class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https:pandoc.org"
  url "https:github.comjgmpandocarchiverefstags3.1.11.1.tar.gz"
  sha256 "3677b92797dd596b2f05d80ad7517ac9a07c1d419748d91fc491c457f3873fb9"
  license "GPL-2.0-or-later"
  head "https:github.comjgmpandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05aa3fe48d9a44db97cdb007f0aaa5a257cf843f0377fbaf5943135390339d9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b80165b7bfc9e8107d9970c0356d6473f943622e79f57b35d900047cc714fa2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13915800eb635f6ed3c1666a6d4986c048cf047968695ee4772b1d3eaade5ba9"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec7b8c7fc8b95d5106d3414c2e65f01412dcb65f48b56e0bc837e7cebd295f5"
    sha256 cellar: :any_skip_relocation, ventura:        "72b0151a5a02884087080955a24053658a85f571abc95fe49a1b5dd9afc73717"
    sha256 cellar: :any_skip_relocation, monterey:       "c054f92bb75c9ef21b316f465416c42801547722dbe2791741c07f206048da79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13b42e314adef0c285a47a7feb993c8bc1438328e5de7e27491ea676a8b66873"
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