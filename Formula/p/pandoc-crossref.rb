class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.17.0c.tar.gz"
  version "0.3.17.0c"
  sha256 "9c391e87acc711b495a754623374734f38e5bd2849eacbcf03f011fd62399b64"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "066174071af13a42f036b8daee3a156595868162fe98610264172fa5782190f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb1b4977c05bdce083cc929f65a1043d3ae403b3bbe0f74bbc5a8cad3c420655"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "779903b8c4864aaf5123aa91fe2c7e2e27b8d4a638cb14bac1879762877b1198"
    sha256 cellar: :any_skip_relocation, sonoma:         "3208ce8fb7d8772e72ecbba69d85d04bffab814faa4c8154a67486f040b63a43"
    sha256 cellar: :any_skip_relocation, ventura:        "a5fabfd178f40240e0c56c1823804f715c145090d98ca998e31b47d7b242691c"
    sha256 cellar: :any_skip_relocation, monterey:       "d681fbee334da7893f754451715e56ce488a18adeacb95b69c4ff21537464682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "860dc1b3aa0b7bff2b0aaf134c8c2c54b3b30524baf189c621148e721cb02bc3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    output = shell_output("#{Formula["pandoc"].bin}pandoc -F #{bin}pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end