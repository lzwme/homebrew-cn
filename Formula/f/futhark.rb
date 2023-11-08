class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://ghproxy.com/https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.7.tar.gz"
  sha256 "64afb1b228b377702a35b558cab2e58ca260e06fd402048dd457d8b944d6f225"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0783cfd57693b56356cb86c6c9efdd36ab33a1e3baa5983a083a7dc850c50d43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25d5c345090a27c9a1dd2370fa1fda8a4ebcdd119bce1d44aa41f3918510687e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fd7b224313685ca7664cf974071e5cbced9266f400af18153fb309d6fe5a8a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "647371a28dbc1baf95fada063f37db00a4ed59de9ff5958dd42ff1d2beaaf855"
    sha256 cellar: :any_skip_relocation, ventura:        "054d5366c84e3b47c9c1d4fb07d929d69461858adde79699e552d69ea5cb2689"
    sha256 cellar: :any_skip_relocation, monterey:       "990cf6e430518fcdff74bea7e4d8fa466d51239b9698b18d20fc343e7ae0977b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13abdff92897fd8f3a46358a0d4ba6beed7a78c8d9daad3a5199deeabe04ed22"
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