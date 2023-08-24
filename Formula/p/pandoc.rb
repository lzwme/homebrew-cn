class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghproxy.com/https://github.com/jgm/pandoc/archive/refs/tags/3.1.6.2.tar.gz"
  sha256 "f614b9de4d42f1c12623e0effb4bc945cd2a2dc966a68d60206bed1bd1cbc097"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "669219ca7e2eeb53eb95ad5a6f7b2630003deec782a3fd0a0e0892f302c289be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69ecbf42e9ed4e0f2eba77a2162393627cd4a0512f3840edf32ec177563edff9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43c3c350d30d3d9d46185114edde627de8a5c84090b80c4927596f1317a72406"
    sha256 cellar: :any_skip_relocation, ventura:        "9e74e5d69fcfe23f5cb8ea4ba640a88abec0b103e27c00e23dc8bc93a2bea7fc"
    sha256 cellar: :any_skip_relocation, monterey:       "0c396ce29c1596ee7b602527da9500b860b6da5c376489a6573470eaac74a698"
    sha256 cellar: :any_skip_relocation, big_sur:        "a07bb76c781b1a04a158c9f688413e6d7b4972adc182152bd732ec571a1dd492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e2f7a781f6ca42c0573e2ca046c52c47842b48b2d9d7be3931bb0f0c85683f"
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