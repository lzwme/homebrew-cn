class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.19.tar.gz"
  sha256 "8a30bf9a1d5d716ddfb5fb05bb17e96c121e63a31f95d82d7f369380147e5a06"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4efb5dff57473f27b655851490202f3a90c292e91aeb0403b2971005987f1a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b81878c8e32706dc3718f899442c26ccd845446266d5ea60fc049b298cd6a41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db12618b2a2409631165554ed34b2eb8b6c2168ba52cfe1eb7189cb29fa43058"
    sha256 cellar: :any_skip_relocation, sonoma:        "90cb8bf5ce834a2beb0ba1823f5a8d1ee23f3d0d2f3dac3e044c9f89f5be2946"
    sha256 cellar: :any_skip_relocation, ventura:       "5ee9a7aad93e998535509baa1da1da6b922587fea51b7851d41f466354ac7987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ac3d707de4b39f470a5bd4b50a7ebbb5ce48c36ded06d59355fd1dc3e88ba82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "907a754a89f7431430e5cc91c814b2ee9a455fda7181b34aba21990ec8bfbe84"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  # support pandoc 3.7, upstream pr ref, https:github.comlierdakilpandoc-crossrefpull473
  patch do
    url "https:github.comlierdakilpandoc-crossrefcommitec8170da048712ecf354cb3a234e15c627d83568.patch?full_index=1"
    sha256 "af7159ce95aa90d7ff1723c64b4e0074d0734756dd44592406f8e0f94e7eab5b"
  end

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