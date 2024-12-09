class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https:pandoc.org"
  url "https:github.comjgmpandocarchiverefstags3.6.tar.gz"
  sha256 "9e5dcca8a8a0a24742138cb95c6e8c125dfedfda0c004d28ae2c9fdd297cf699"
  license "GPL-2.0-or-later"
  head "https:github.comjgmpandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60e64c5532625f8446a1c346680f201996a79cf65c48260134d47456809c0b64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aef5c8496d44adc2cba4f246ed80e24cc71bfe6cc5b9ee3493289758bbce8a76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35f56822cf2373b584cd76cebe35ee1de9deb97f4c8fb2372c99d4f954ade6ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5eae7f7bff301ff049a027430d306db9604f643f574ec2fa2ed0b6203340fd7"
    sha256 cellar: :any_skip_relocation, ventura:       "03a1a61819a90f99d5a7e5861149d141f4700a7a45a8b8e3867fc2833ddf4938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7763840ffd631f34d0d580d0d9eed4dec99e42ad3fd904b2354c9732fe51d547"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

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
    input_markdown = <<~MARKDOWN
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    MARKDOWN
    expected_html = <<~HTML
      <h1 id="homebrew">Homebrew<h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.<p>
    HTML
    assert_equal expected_html, pipe_output("#{bin}pandoc -f markdown -t html5", input_markdown)
  end
end