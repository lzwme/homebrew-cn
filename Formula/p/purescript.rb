class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https:www.purescript.org"
  # TODO: Try to switch `ghc@9.2` to `ghc` when purescript.cabal allows base>=4.17
  url "https:hackage.haskell.orgpackagepurescript-0.15.15purescript-0.15.15.tar.gz"
  sha256 "9c4a23ea47ff09adc34e260610beabd940ec5c15088234cf120e8660dd220e67"
  license "BSD-3-Clause"
  head "https:github.compurescriptpurescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69551d14eb101c3640582d055929b2d6338310c5422530edb2b1e35dbd648830"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "720d717ad6d38ba67c288cca2cc03b236cf29ed3badeb823743d1ab091f8704f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d4a9daf4fca5b870a4e45590a13e56e8e78f9bef3729047f064a48a86e7e3f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "133fd37b35ea0ebc610965f55332f02bbf67a00db14c4b518f9e7b714fdd705f"
    sha256 cellar: :any_skip_relocation, ventura:        "25f3df8f4c4e5eaf94f4fb9411dfcd48ffaaf257f96e454eef88ff387dd7bc8d"
    sha256 cellar: :any_skip_relocation, monterey:       "a5cf0585bded8ce93f09124d885a8dc00b373b6ca63407300d5b3bcc10aebe9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07fee914dfa9648df6df6152b7c5d7f0297d2e8133a653a4f3511dcfb72b01c"
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