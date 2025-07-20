class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://ghfast.top/https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.32.tar.gz"
  sha256 "84adb13b3b484cafcc40ac7263c56c26b2cc7035c246ccbb599e2724bb2fa73e"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77053725ac378db64fe1340bca282e009729ef9d4c7e2b1bb61e91f30bee50c6"
    sha256 cellar: :any,                 arm64_sonoma:  "012fa53882e53970bc518d55faf1806c0d891952f284e94aa4c47eea2b183147"
    sha256 cellar: :any,                 arm64_ventura: "526803bdaa4cad69cf43e53c04f5a261d9bed68c99f45c91d4dc4571e076a773"
    sha256 cellar: :any,                 sonoma:        "f8831472a3ab6b0768c45549a32466fd8448eadaa13d707757dfe8550e94fece"
    sha256 cellar: :any,                 ventura:       "5d88558367908ff7b45e47e04f53897e65df8d7b2e5feb06796742003c6486d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05bcb2e2ff693b605a206f4280cc340ff8be97eb63a68aa1326dd2e89618221d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f4618681b3728360264857df3bf615a93cbdccdfde46a801180fc86ff2126f3"
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