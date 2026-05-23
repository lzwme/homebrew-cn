class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://ghfast.top/https://github.com/diku-dk/futhark/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "8db77cd631e2e9c60ddf4fd19c1b5b46f6e636f541827ffb449758dfd16a7536"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8eac3541e394a1f371a3265848622bc6ae159cdd3703683f1acfd823bbab71ff"
    sha256 cellar: :any,                 arm64_sequoia: "eb4fd4cad611773ba8fad592dc17d0517ec72d8bdd805b14e1d24abad6ce2ca0"
    sha256 cellar: :any,                 arm64_sonoma:  "13190ab3a8bad7ca33381c5b58437b794d911131179e0eb2a13e908d6f0cd5bc"
    sha256 cellar: :any,                 sonoma:        "332e9116471d75f99158c7548b285944625f27781953426e1d8ce12d04c766d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d58285b7c6c3128a41123167d4c0f7dd484d8a281eced34fa8cb51043bc4b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0edcf5c932c7713eb8670e02722b0318763c3be5a363eb3dc39fe6024e91b3ea"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end