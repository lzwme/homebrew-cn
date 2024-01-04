class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https:www.purescript.org"
  # TODO: Try to switch `ghc@9.2` to `ghc` when purescript.cabal allows base>=4.17
  url "https:hackage.haskell.orgpackagepurescript-0.15.14purescript-0.15.14.tar.gz"
  sha256 "450d8bce772ee0a3b7ded51466543649a105f4aedf2469fe1f7687233b638dd6"
  license "BSD-3-Clause"
  head "https:github.compurescriptpurescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca8bf3200e2350fb82c629305c82c63fdf7ad4cdcd20cf45e397c86638526ae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8d3e4d87b6b3e9cee6c291874507bbcf6b0dadc20ee749c7149ed17422ecc2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b9096b057977b760f3900bd739ba1830ada3d533b0c4b953d618b601495986"
    sha256 cellar: :any_skip_relocation, sonoma:         "0729b94e98aefe987306828ee41c2585056ffe68a2466709b959c84cac779110"
    sha256 cellar: :any_skip_relocation, ventura:        "6cea3e4fe34b6c73711bc30090270ba2477adfa29b4e8fc4472d4d5e3bd4cf7f"
    sha256 cellar: :any_skip_relocation, monterey:       "cf88bd9681fa94a0828d854d904ca6b73e896bbe58dcc08cde7c30c9ecab4d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f82167034c5aef33b927dba3341728a4c19107618313356b35806905dbf2a6b"
  end

  depends_on "ghc@9.2" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Use ncurses in REPL, providing an improved experience when editing long
    # lines in the REPL.
    # See https:github.compurescriptpurescriptissues3696#issuecomment-657282303.
    inreplace "stack.yaml", "terminfo: false", "terminfo: true"

    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
  end

  test do
    test_module_path = testpath"Test.purs"
    test_target_path = testpath"test-module.js"
    test_module_path.write <<~EOS
      module Test where

      main :: Int
      main = 1
    EOS
    system bin"purs", "compile", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end