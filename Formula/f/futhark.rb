class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://ghfast.top/https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.35.tar.gz"
  sha256 "847f9f75c2b64a06c062ce4c2987fb2be95898300d3562124a384b5a959b810f"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a29e7dce1102f0f8f42ca1a27b0a786a0d0145e4356f604a283a6c7df3be3a6"
    sha256 cellar: :any,                 arm64_sequoia: "68dfd8bdc0898938643656291dbd38e65d071393f2da914dc22e4c8aab5d76a8"
    sha256 cellar: :any,                 arm64_sonoma:  "1a9b5aeb2a3bc1d417e72707628dde384e7c93e9a10ea66cae2c2c37f9555717"
    sha256 cellar: :any,                 sonoma:        "dcf9e0983ccfa31d0016e517e1e6817861002245cf741c48f72f3bfcd3ac8f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a0e3d39269ffb9faeebaf64dcdb17c1038deef11020bdc17f1c0d1f7d47e1f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9629aea0a3e78068b324a20adbcb95004ae7bbe9d90d88c64a7ac0f442a21baf"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
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
    system bin/"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end