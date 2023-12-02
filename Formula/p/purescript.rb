class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  # TODO: Try to switch `ghc@9.2` to `ghc` when purescript.cabal allows base>=4.17
  url "https://hackage.haskell.org/package/purescript-0.15.13/purescript-0.15.13.tar.gz"
  sha256 "cb3e8ed2c54af63e950e784426e18a02c572bf356325f20fbff3a98df04222af"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9635623fa99414c51f6513d033286e1dbaf26f0ddc2809f81293f9d9edf01ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4c20bde2362823f1dd1248ea0f7afc516b97bd723a733ff547a59c4471ca454"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ee3f4e7d07ce654f35f099388c894a2aaad6bb9722a79f133e517e7700de762"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d56e03f7fe3ccf85155d0b65a9644c7fff35e30a8eed7d87d44cae9e27b8c15"
    sha256 cellar: :any_skip_relocation, ventura:        "3e090d221fc65ccde1b9682d6e11e34cf40252f6a63b2dd7e4dd88825e7fd0ec"
    sha256 cellar: :any_skip_relocation, monterey:       "5ec9786de4f2d893eaa00c79b8b38bd62c1207552a09414046173f96544f2b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c374cf844b34785ec9f4c3b1d771b5e533c4cbdf0f82b1560c4c66e1bf19f811"
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