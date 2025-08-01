class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghfast.top/https://github.com/jgm/pandoc/archive/refs/tags/3.7.0.2.tar.gz"
  sha256 "a098c1dc8051844e3992f8396c6c947dccbc57b6ca3df2f2c47b9f7fa9f11246"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3c56ef545678a26d526a8b4dd1f3c81fa01fa7570e06776082c2f4dbfadfb6ce"
    sha256 cellar: :any,                 arm64_sonoma:  "708d8c6efacab7e0b956c8569350efad991cfa7851da37efeb1b542a1f98b9f7"
    sha256 cellar: :any,                 arm64_ventura: "6c6505d4c3accd3e0aa0150b50dad2ad1dc5d40941c8b83114b5bd3425633bb5"
    sha256 cellar: :any,                 sonoma:        "19f1e26349eccf0fd2e23bd1a5aaae30d07fdd3bbb09a42f2ffd6ae24518765f"
    sha256 cellar: :any,                 ventura:       "12877bdc7d0889e836fcac5c358be0f409c01697f36ae61e1f2b1653cb0180ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea51a2e3c9d189302ea91c884d4be0c480728f01a8a24124ed25892ecfc1378e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3536b713574d366df256fea61b6ee57560e539f8a8562feef26258096f9bc7d1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
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