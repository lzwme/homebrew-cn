class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://ghproxy.com/https://github.com/diku-dk/futhark/archive/v0.25.1.tar.gz"
  sha256 "0fe50a3501d9506f9225632d205e3d08beb3bd1fc159dfc97a2c56cf2e548b0a"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95bc091b164231de45559b2247154e781976db645782c9bde999eda0c3abaa6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bf3ca90ed3e7a65949f0a98f02e6301cc79c9edfc5327f0138b6179020dca39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee0ba62241997fbc60683e3f79fa09740e438025836d5c8a0c59652edead5dde"
    sha256 cellar: :any_skip_relocation, ventura:        "707c35852d2b29c14af51a4020163ac6ad62f62844f32ed7c6e2aa41b7a98e7c"
    sha256 cellar: :any_skip_relocation, monterey:       "0a9f3c54e48a7ee2f975ccd8525e80315f41714d163bf2dbc3a753d315bdd744"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6bb797f24b70a0bb05e5af4ffa264c8e2e265c971ca3647af7d3e4f9083d64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b7beff54018c71e78a482ed14d802717b20c9f3bdac72b4acf7355596bd166"
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