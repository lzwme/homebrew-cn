class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https:pandoc.org"
  url "https:github.comjgmpandocarchiverefstags3.2.1.tar.gz"
  sha256 "c8b360a12b9b2b4be33215f212b444e6110aa7dcfbe49e84f08914855ad9b39a"
  license "GPL-2.0-or-later"
  head "https:github.comjgmpandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71aa8f94344ca2225f7283c0cdd071a7092864311e7eecda46837b03f8ebad70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e36d3451e9d643678928ae6f918ddba31262c5664b6bcfebc806284b0c89c04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "940c5b287eceff59abcbe4d8e10f6cabddfedffed44c59dbf70e3bcfb905fec9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8542e137199f62d70b026d28fd0d4abc03354299877edbd69ad75e160164de56"
    sha256 cellar: :any_skip_relocation, ventura:        "bc3330c3d3c449accda00313dfa12348957f8766d5323a4cc3c353c64496c4a3"
    sha256 cellar: :any_skip_relocation, monterey:       "f9db0c6ec4ff19ab1cfbc2acf49ed87a3165b610fcba28fe708d9ff4239fed99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd181ee1efe623c8884c0afa34beee85ed55b71262c225012e1e43ad68949633"
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