class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghfast.top/https://github.com/jgm/pandoc/archive/refs/tags/3.8.2.tar.gz"
  sha256 "d8f08e0228958522073ceedfae7ba463703e6212dd823868f0b7190d63ccebaf"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc466877fc54b4f6abee3ec775ea4ea1260c35752e4ebd41c3f542967dc035fd"
    sha256 cellar: :any,                 arm64_sequoia: "4ce5a46d715eadb6c494d7ab113fcf224e7ee3ea6d6a46876780bb4ee4e31af7"
    sha256 cellar: :any,                 arm64_sonoma:  "61421b27ef4ab8bd0d0b9ca174a6f7ee1c20bf985a497ad1657e22f9eab4997f"
    sha256 cellar: :any,                 sonoma:        "449d3c7b088ceec9acb473c39db709ae2e97b57853279d9c6cc154eefd434e4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e375b021c898531456ced6306d39912c66cce4be2461957b020eef68d94b317f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d8342f3de71bd59b054fa1c564b09dfa133850f9caf06a06bf225e58ee2cb77"
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