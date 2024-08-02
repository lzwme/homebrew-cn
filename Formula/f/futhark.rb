class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https:futhark-lang.org"
  url "https:github.comdiku-dkfutharkarchiverefstagsv0.25.19.tar.gz"
  sha256 "0203e40ade19a208785386887ca8d8a9e0d378e4d1dceed88b130e20e56acbc8"
  license "ISC"
  head "https:github.comdiku-dkfuthark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df98d3992eebf2dbde9c1d93b1c03668f3511ed2ffd4c5da463b60706c028b2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa7a893c47c3deea3f05bc57e43befec73c777a07ffa30abb58b700183f6e5e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d447614bb2420563617920346f38743e9cd415c20f955dc7408105aac52032c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca89c31abf281f04a5ef59de17dc342821045a3bdd44c808589d536e31d2a7ab"
    sha256 cellar: :any_skip_relocation, ventura:        "d20202fcbf522fc331cf3767050481309e98617b56c7eb8b1abea123b0a854b2"
    sha256 cellar: :any_skip_relocation, monterey:       "0fe890b9ad704d9c62dec368d393e7e6e73b1370d7bd1b2e3f23ff4957ee53aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8d5df1b17113ab63b5bf3971fe8d7db69ab94695176c48b85b4607695fbe761"
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