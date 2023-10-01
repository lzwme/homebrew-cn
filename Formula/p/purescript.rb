class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  # TODO: Try to switch `ghc@9.2` to `ghc` when purescript.cabal allows base>=4.17
  url "https://hackage.haskell.org/package/purescript-0.15.11/purescript-0.15.11.tar.gz"
  sha256 "9abdb05a58f0f94a6f27a9edd47fc8fce01710aee21a5b85569dc0d34cb757fd"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "562b9fc19cf3982474212361fc0316d18f6aecd0cf51e8c1da55fbe65922c508"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9488ea1d3ff4cbc880be15defd456542173737d784fa0048a0dc696a357ee8f"
    sha256 cellar: :any_skip_relocation, ventura:        "7fcc604af76493847944092274a26fb28379f419efefe4d4cd389a5321e2fb84"
    sha256 cellar: :any_skip_relocation, monterey:       "cf1224b8555fa563c3a759448d635e05be8d17e2a3257ef718bc4da1a38856b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfcbe082e6299684efb5125f356e57f951d1ee26e4e665cb688405579d64f83d"
  end

  depends_on "ghc@9.2" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Use ncurses in REPL, providing an improved experience when editing long
    # lines in the REPL.
    # See https://github.com/purescript/purescript/issues/3696#issuecomment-657282303.
    inreplace "stack.yaml", "terminfo: false", "terminfo: true"

    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~EOS
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end