class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghfast.top/https://github.com/jgm/pandoc/archive/refs/tags/3.12.1.tar.gz"
  sha256 "cf9b3725b90e471aa70c99ac3b351adcb6e40cd904d36fcbb0f70d712e135686"
  license "GPL-2.0-or-later"
  compatibility_version 9
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "fb21dbddf91dd13030fa6ddf7d3cd82aa980e731866000dff515e78ddb695ad7"
    sha256 cellar: :any, arm64_tahoe:       "4089a8672e1cbf7cf4db44fbc9565ceeb85774057d2fb391a97a7681cd5f9fe1"
    sha256 cellar: :any, arm64_sequoia:     "37d956bfa4f582a2759cdf2b343854e5469155edd82d1b05907af63bd928b5be"
    sha256 cellar: :any, arm64_linux:       "594f03b44422a43e9da5c3878251b74457fa879965842033732355e4d8200c03"
    sha256 cellar: :any, x86_64_linux:      "584f8506242e45fb2a248f612ed0bc72c4a11a7f1c75be20dcd9aa97e711ae87"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :build

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell", "--constraint=pandoc +http"]

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