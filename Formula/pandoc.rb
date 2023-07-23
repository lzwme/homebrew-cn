class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghproxy.com/https://github.com/jgm/pandoc/archive/refs/tags/3.1.6.tar.gz"
  sha256 "3194ab5b37ab1b80bb0be023753fbc78207df5f093caeb2ac6edb5dc0d5e704b"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9281378333e7fac667e388d8d5e113b182ebb2b1f93b689c6336b4fa2cf0c64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ead467e3ed83a3a7bc8eaaaaa91ca10c8ee671b596bbd5b05a3faef6e01e294"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e85cd0715fcb0983b763908c8ac43e8507916e1bdd1aa3f92df63cfcc64ca41"
    sha256 cellar: :any_skip_relocation, ventura:        "0461a5609a16c3fd71301ce6490f10e510a2d3cc6105c15785bd1b4c0d656d58"
    sha256 cellar: :any_skip_relocation, monterey:       "536049250c8ee30fbb85ff98a5e428c11da99d3c68f20fc8a7b88c6189f4b672"
    sha256 cellar: :any_skip_relocation, big_sur:        "1691d5aaca8782b1f857ad77083326a0359d3ca59436d0bc281c46e11c48257b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa1cd2f31d7470c8970b4f8c644f333ad27b9ddc68ab99e37349f589827e3dc8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end