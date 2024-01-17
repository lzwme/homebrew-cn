class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https:futhark-lang.org"
  # TODO: Try to switch `ghc@9.4` to `ghc` when futhark.cabal allows base>=4.17
  url "https:github.comdiku-dkfutharkarchiverefstagsv0.25.12.tar.gz"
  sha256 "06abd3fb0b119857bc64de3f13ae6e99886b269058821f1a2007b79c63384b0f"
  license "ISC"
  head "https:github.comdiku-dkfuthark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94c554a1fca6f57f34d94750047ee8682cf1e8ecbe77d8110a982b77173fa974"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89fc40016a2c5e6b318e47cdd7d4f7157483616067e03756c4ac45922ba60ca2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bacf7c64de83c5516b4904f115c1ef8a1369f3e6ad05715096b844e3594419fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad39fc736c68737ba2a1e983c30d47c0f706486394c6fe959e54ae09c725ccac"
    sha256 cellar: :any_skip_relocation, ventura:        "ff637da2d1b0a7cdeba1e15dffcb9be2e785be000485914230217e85b269be97"
    sha256 cellar: :any_skip_relocation, monterey:       "beca1518790304713ac99810d09072e9b91d28ee5f38b8afcdb51fe4eb461ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370a9715bed81739dd0d8fa6d0ac03c47a2d50874cf1ea30bbabe5cc92fa7a0b"
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
    man1.install Dir["docs_buildman*.1"]
  end

  test do
    (testpath"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output(".test", "10", 0).chomp
  end
end