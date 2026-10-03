class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghfast.top/https://github.com/jgm/pandoc/archive/refs/tags/3.12.tar.gz"
  sha256 "b19c416525f00e2c35a75dc377c767a57084ac22a9f1f4f9c5f6448dabe9819e"
  license "GPL-2.0-or-later"
  compatibility_version 8
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a6cfac00424ecad63a151fa4dcee6bd4c63eb136a5993ba18e925f286aa8542c"
    sha256 cellar: :any, arm64_tahoe:       "df18396b3e554b62a141a69b13e02d63ced830f7284bf0271d53a5b4e2ad55e1"
    sha256 cellar: :any, arm64_sequoia:     "54c17fb8d8e20c182ff74c3d4d6857b2ba77e1114fe4d68f3252659867f1caf5"
    sha256 cellar: :any, arm64_linux:       "7e14f9f22ce792997281a2d3807649a4a23eff820305d29b4cea23328c5b8ec5"
    sha256 cellar: :any, x86_64_linux:      "90fc8154b015eddbc76b306ddc74c9cb20926942b9911bac51a3279cfa1eb8fc"
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
    args = ["--allow-newer=base,containers,template-haskell"]

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