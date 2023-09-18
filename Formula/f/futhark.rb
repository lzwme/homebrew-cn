class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://ghproxy.com/https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.4.tar.gz"
  sha256 "79c53a45b822a89c1ff869e8f6101a3489336a6cf1ff6cad94916b7f7f645572"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79b5097439c58235f25e2245ee5279e448faaaa05e72baa76f70fa2dc4005dac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7a527ed17316a81ff5288083f4c33061e81c8abe17581c7c4f4de59fcca5534"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "462d2e120ce88c531f932cd5bc72658ca1505e28dfd0bdcc7d4aaf403014abd5"
    sha256 cellar: :any_skip_relocation, ventura:        "3df77f108653a1786a6e985fa04582e3827a133bf7777acf12e09f849e70f0be"
    sha256 cellar: :any_skip_relocation, monterey:       "70204a0c142b9bad40ae9c9ecccd929f6f2a81c59d55f6f7d3fb7f0cc8afc466"
    sha256 cellar: :any_skip_relocation, big_sur:        "a28e35b0f831682ed4d68c0676ef4f3239cd0e34f1451372215af6df0fe04bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeaef6d42aac00e71bb16f7a50d383a5549321693c1193a580124e2e0167671d"
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