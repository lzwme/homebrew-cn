class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.18.1.tar.gz"
  sha256 "d41c7fc7e9f1fd3bff72d96c0693458aa18b338f65390692baf277c305f95ec4"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc2e344a20ad3f0966949de793f6ba5fae6dcf7b1c55a0fcf4fff7bd427069eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7bdd453f1cfb9c983ca6d81604ced305cb9107268ea45c92d644be9effcca25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4676c8a3f603420c9673875fa5ad18a75325887028c2a1170555c38f82831d80"
    sha256 cellar: :any_skip_relocation, sonoma:        "c47ac861f2dd8e5fc94a2a70a9a670afbeb14c4baa177854afcdd48df2b423aa"
    sha256 cellar: :any_skip_relocation, ventura:       "751fff058b26a4483a42a5e86300fa1e198c8801ac97accba63f61f3b7e4ebc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24680f6eaba7053555a86356066e07efe3ce10727d8ebb48b3bd58755d6db18d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}pandoc -F #{bin}pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end