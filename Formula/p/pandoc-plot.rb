class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https:github.comLaurentRDCpandoc-plot"
  url "https:hackage.haskell.orgpackagepandoc-plot-1.9.0pandoc-plot-1.9.0.tar.gz"
  sha256 "ea453cff15e82b9af3461dcf5918e2329267a5aa3cd9b609feeed690c87fbec0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab31eebaf137704e1beb2c23144fb505043c5812e57e80cfc6a3c995ecf00277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386e996536f4eef3d029f23758c4a2156bb3eadb91c3efe3defea6d4704fc9d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46b5797541e719c6bbe86d114b19634bd91edaae02701a3a3e0f49ec71bb8ef7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4940122cde59e68204ece7a83823d8bf6b10ef011a0395735df4f2a39188c025"
    sha256 cellar: :any_skip_relocation, ventura:       "b6cb1be1ca258928a8d7bfa52fdad70720ccec3c7ef832015009165e4763c56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef903bcc808bc04a4558f2be50266f41b2282550ae9ba019cc8e07941445ef3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "graphviz" => :test

  depends_on "pandoc"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    input_markdown_1 = <<~EOS
      # pandoc-plot demo

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    EOS

    input_markdown_2 = <<~EOS
      # repeat the same thing

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    EOS

    output_html_1 = pipe_output("pandoc --filter #{bin}pandoc-plot -f markdown -t html5", input_markdown_1)
    output_html_2 = pipe_output("pandoc --filter #{bin}pandoc-plot -f markdown -t html5", input_markdown_2)
    filename = output_html_1.match(%r{(plots[\da-z]+\.png)}i)

    expected_html_2 = <<~EOS
      <h1 id="repeat-the-same-thing">repeat the same thing<h1>
      <figure>
      <img src="#{filename}" >
      <figure>
    EOS

    assert_equal expected_html_2, output_html_2
  end
end