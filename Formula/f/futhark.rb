class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://ghproxy.com/https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "76ecb969323b3722821cbbfe03029a9f54fbcf48fb1943e696f5e3de7c74d482"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "808c04c238acf5b68cc0b8e0c8145018e014e1cf0cbeddfa52c19e67220a5752"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d58a63b89eed953ccbcd44e6a072cc94971c78319048c67ad04cbd8cba6194ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e9afeabaa01c1e0cf7fddb26ab0fa1cf4f92211dc9799a65ad4d0dab8cde67d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e19c8a49ae4a852a33410608b1ce8a9f078a35654677c0bb78cafe9e38eb0f1"
    sha256 cellar: :any_skip_relocation, ventura:        "3b5bc611427bc1b281eb812f93cd370e8844c0cad510821c43d9f8d95fc2ceda"
    sha256 cellar: :any_skip_relocation, monterey:       "d3d0aab31542acfbe3c95d4e1c3ed127fbf5720b4fb380449956f7ccf9476c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fad09e4d1637623ffc5817934ff5deea87bb68ff7b4d9f6f6855262bb4cdf23"
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