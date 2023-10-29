class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghproxy.com/https://github.com/jgm/pandoc/archive/refs/tags/3.1.9.tar.gz"
  sha256 "cf41392889f1cee2a593b52fd9abfcb6996a70bd7640db3c10ad915ce716c2a3"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "881cebbe75b9f13288d7c5b1102a963d4878e726412618b470dc59242e2d5d6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1d60cea6bf23227fe1ff472199e418176aa5194e82ed7c786b926321f277794"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7421f707a90a00359e605dfc504d46b089b5f5dcabe3f4a9f806837137333a76"
    sha256 cellar: :any_skip_relocation, sonoma:         "b76ae1e043456eb6d7674ecd91493ca748448d6fbb7a9db5e27aeadda8513714"
    sha256 cellar: :any_skip_relocation, ventura:        "b083b7f198ee76651c74d2e5966fc574816c93a709f0a32e064120095fd1ae33"
    sha256 cellar: :any_skip_relocation, monterey:       "2a16a24ff78bbd6d6fb1edeb0a9bcb6942d3ce6850a606f8737560ee8c8d4ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc523534694f7f16b43dbffac43daaf0d9c21c3c62d0c7e5c72b27c2a75b76a"
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