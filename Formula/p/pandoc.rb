class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://ghproxy.com/https://github.com/jgm/pandoc/archive/refs/tags/3.1.10.tar.gz"
  sha256 "a37832d5a462e058b9d98c2b2a5b6c6d3d45706b7850d26d11a4b9c17e14c6dc"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88c5a2f0bb304ddbe68172cc498b7d12a091eab7d60959504901d43ad65a45d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71e8c865c303514c64cd0764b10f4285c700502a10d3612f99f51a7959d28548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "987a3c1e0c529d88924f287c9cbbe167c925d587d343fe3fdcebef9bb6a97b06"
    sha256 cellar: :any_skip_relocation, sonoma:         "25852a9c7342eed067028a0233dce64d3ad41866fef6cdc1a30e7fafe6337df4"
    sha256 cellar: :any_skip_relocation, ventura:        "20bfc7993c08d676442dd6a0b86a81886c1a9d8b009106ef419fc4447b271656"
    sha256 cellar: :any_skip_relocation, monterey:       "f86608ee1f28d240d7352fd017cc26898b8fc7dd3620237079c9a299ac74481d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13253774ddeb52f1e5fcbe1c21193ef88638741abe469544f5091f44c4168ac2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "pandoc-cli/man/pandoc.1"
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