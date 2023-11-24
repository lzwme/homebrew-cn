class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  # TODO: Try to switch `ghc@9.4` to `ghc` when futhark.cabal allows base>=4.17
  url "https://ghproxy.com/https://github.com/diku-dk/futhark/archive/refs/tags/v0.25.9.tar.gz"
  sha256 "bf7bc33d8932fd63b0880e6795945d9bdfb4f49baed75f9d2d46e41842fefae1"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9772afb26dc1aefeec857c7129997d8de59f653478f39faef3f1d28e8c21f5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "405559b05093fcbede3238f44990295d5506e2f9ce1a6acdba0b41c600bda405"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b853e908f74d2fc271917c2cf354292880169dc6ad883ff0bd33ca9c3fd05de9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7453c0fc3354018ed55d0f4a1d55789fdbcbd827b32485b27a554284be0d947"
    sha256 cellar: :any_skip_relocation, ventura:        "376109445bb1a5844e6849df50851b440b68dcf6c3bf14d0a0b78264a8065f40"
    sha256 cellar: :any_skip_relocation, monterey:       "0a80c40b59a60bc16b965215b0559e1b0439d895699177928eb76cce4dcbf8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb9468c2893900101de131ee9f0d93074a9d26fdcd43f3400ba48d0bf05e079e"
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