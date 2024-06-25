class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https:github.comsolhpack"
  url "https:github.comsolhpackarchiverefstags0.36.1.tar.gz"
  sha256 "b247efa4e7a29610b8e16f054d5201ebea4df5d68b271dfac8762081d589f40a"
  license "MIT"
  head "https:github.comsolhpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc3f421554dbab3c70ccf922f5a0ec70a899479d637d7f960c8a170f36e7fc8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1881337297c2bc2b6188640dde23defb023d6d313afa73becfe6612c16d5fac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "071d0a86e79df1829552d4b68886569dcc683aabc55ba4cadb6753d1e479c94b"
    sha256 cellar: :any_skip_relocation, sonoma:         "99bf2872b37e5d66ba56cb290d78a5123f365ea5ecd48ab48d36e2bd319de61d"
    sha256 cellar: :any_skip_relocation, ventura:        "153041e4a6ddb150c817d86be694f481a9bc08736cea5344b577fd780aafbbcb"
    sha256 cellar: :any_skip_relocation, monterey:       "83eaa210607b0c66f44bed20445f8651753b06ad3ce1401da73ef4d80ba7385e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bbe518cabc6e9c9e096447c5323e4081ed6e127bc18674cf786badfb9b2a588"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  # Testing hpack is complicated by the fact that it is not guaranteed
  # to produce the exact same output for every version.  Hopefully
  # keeping this test maintained will not require too much churn, but
  # be aware that failures here can probably be fixed by tweaking the
  # expected output a bit.
  test do
    (testpath"package.yaml").write <<~EOS
      name: homebrew
      dependencies: base
      library:
        exposed-modules: Homebrew
    EOS
    expected = <<~EOS
      name:           homebrew
      version:        0.0.0
      build-type:     Simple

      library
        exposed-modules:
            Homebrew
        other-modules:
            Paths_homebrew
        build-depends:
            base
        default-language: Haskell2010
    EOS

    system "#{bin}hpack"

    # Skip the first lines because they contain the hpack version number.
    assert_equal expected, (testpath"homebrew.cabal").read.lines[6..].join
  end
end