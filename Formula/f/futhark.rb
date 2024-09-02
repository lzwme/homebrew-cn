class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https:futhark-lang.org"
  url "https:github.comdiku-dkfutharkarchiverefstagsv0.25.21.tar.gz"
  sha256 "241e9908c2ef5071a53fd39b36414790dea085bf2b7bc913725d395fb23ad97b"
  license "ISC"
  head "https:github.comdiku-dkfuthark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4eae53a4972001cb11b9645bb805313b53062a62ea1946aab7b1da488b9b3dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8175c4da540ef3fd491916f85080111d82f1cfde57a48b63169c7ee21efae3ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cabb9f3e63cbe45964aff2dda53e0915a85a7aba3e16d517724c162428f22d56"
    sha256 cellar: :any_skip_relocation, sonoma:         "033e33226cfc5b97185e1301cf0402025712385f51cde70395f358ec199b8cab"
    sha256 cellar: :any_skip_relocation, ventura:        "f9f5b084817efba8654b2c1b53ceeba23437b2aa0ca55e3b0563ecbf864787d6"
    sha256 cellar: :any_skip_relocation, monterey:       "c02d2a62de81035004d032398d227c8083d8966269c2738852add0fd2ee1279e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c337b3d00569e63ac8540956fc61cea0689837a6304ebb2b1f1791afdc17b28c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs_buildman*.1"]
  end

  test do
    (testpath"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system bin"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output(".test", "10", 0).chomp
  end
end