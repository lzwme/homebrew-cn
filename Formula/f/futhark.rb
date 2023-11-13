class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  # TODO: Try to switch `ghc@9.4` to `ghc` when futhark.cabal allows base>=4.17
  url "https://ghproxy.com/https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "dc62d4d9cf411b26f7a6e348c338ff802d303a0cc99291b312b2865cfff38300"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f715bdff2e0d2a891473178bbec081fc71a0d3f655c22e67befd02d71ce6d2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b980b9ccf6d5b93efc3f623120fc561dc437126ddf0fee2817d02e5e39b1b92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "318b06bacc088d80bc74b4657753f9f6f5d804f407210171be816a6424752332"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ce7065106c2da415cb175f2ac7b3d6706bd2e126790d74ea3c393f8f10943d2"
    sha256 cellar: :any_skip_relocation, ventura:        "08c6085cb64ad9cd73334023f9ab2c6c28c57f943a864faedf8d9a66793f10ba"
    sha256 cellar: :any_skip_relocation, monterey:       "e3e14acac065e91c175deb226d8bf2d3057ff51473330840302d2875859f4473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0c55467f1b0bb8957ae52540c5c2d380c503a9f4113fa6ace4033389f02af1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end