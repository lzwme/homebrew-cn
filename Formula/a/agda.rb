class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https://wiki.portal.chalmers.se/agda/"
  license "BSD-3-Clause"
  revision 1

  stable do
    url "https://hackage.haskell.org/package/Agda-2.6.4/Agda-2.6.4.tar.gz"
    sha256 "5b2cbc719157fadcf32f9a8d1915c360c5a5328c34745f15a7c49d71b6f5ef4b"

    resource "stdlib" do
      url "https://ghproxy.com/https://github.com/agda/agda-stdlib/archive/refs/tags/v1.7.3.tar.gz"
      sha256 "91c42323fdc94d032a8c98ea9249d9d77e7ba3b51749fe85f18536dbbe603437"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "ef4eefdfbd5d71c32930df77da8060c3fc94e51ee536847d9d3dc883c8cb5b7a"
    sha256 arm64_ventura:  "018a7d61ab2b69de02c1f00646d8a4b6bdb2b7cc586d4fa96271eec5a9a28c16"
    sha256 arm64_monterey: "b1c468aee3e1f990af584c4f5cdade10cfbb32be81188e1b30993402fa750e52"
    sha256 sonoma:         "ea142d57e89dff3d02ddaba2e991366769fc94fdb6d38fbae2f017b0b7883db9"
    sha256 ventura:        "e9d2511a0bd9eec5feb178130defd3fd17643c893c9d8e19b8f53e125bbf9c98"
    sha256 monterey:       "f572ac521f3a2fa5017a9a28bdd2597c7cc72eb8438a2a81221852a5eec03fb9"
    sha256 x86_64_linux:   "43a31836bc7d6dc93c26b4ff0333b8b23237dec324bbfb63409ed5dfe3ff9413"
  end

  head do
    url "https://github.com/agda/agda.git", branch: "master"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git", branch: "master"
    end
  end

  depends_on "cabal-install"
  depends_on "emacs"
  depends_on "ghc"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{libexec}", "v2-install", *std_cabal_v2_args

    # generate the standard library's documentation and vim highlighting files
    agdalib = lib/"agda"
    resource("stdlib").stage agdalib
    cd agdalib do
      cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
      system "cabal", "v2-update"
      system "cabal", "--store-dir=#{libexec}", "v2-install", *cabal_args, "--installdir=#{lib}/agda"
      system "./GenerateEverything"
      system bin/"agda", "-i", ".", "-i", "src", "--html", "--vim", "README.agda"
    end

    # Clean up references to Homebrew shims
    rm_rf "#{lib}/agda/dist-newstyle/cache"
  end

  test do
    simpletest = testpath/"SimpleTest.agda"
    simpletest.write <<~EOS
      module SimpleTest where

      data ℕ : Set where
        zero : ℕ
        suc  : ℕ → ℕ

      infixl 6 _+_
      _+_ : ℕ → ℕ → ℕ
      zero  + n = n
      suc m + n = suc (m + n)

      infix 4 _≡_
      data _≡_ {A : Set} (x : A) : A → Set where
        refl : x ≡ x

      cong : ∀ {A B : Set} (f : A → B) {x y} → x ≡ y → f x ≡ f y
      cong f refl = refl

      +-assoc : ∀ m n o → (m + n) + o ≡ m + (n + o)
      +-assoc zero    _ _ = refl
      +-assoc (suc m) n o = cong suc (+-assoc m n o)
    EOS

    stdlibtest = testpath/"StdlibTest.agda"
    stdlibtest.write <<~EOS
      module StdlibTest where

      open import Data.Nat
      open import Relation.Binary.PropositionalEquality

      +-assoc : ∀ m n o → (m + n) + o ≡ m + (n + o)
      +-assoc zero    _ _ = refl
      +-assoc (suc m) n o = cong suc (+-assoc m n o)
    EOS

    iotest = testpath/"IOTest.agda"
    iotest.write <<~EOS
      module IOTest where

      open import Agda.Builtin.IO
      open import Agda.Builtin.Unit

      postulate
        return : ∀ {A : Set} → A → IO A

      {-# COMPILE GHC return = \\_ -> return #-}

      main : _
      main = return tt
    EOS

    # we need a test-local copy of the stdlib as the test writes to
    # the stdlib directory
    resource("stdlib").stage testpath/"lib/agda"

    # typecheck a simple module
    system bin/"agda", simpletest

    # typecheck a module that uses the standard library
    system bin/"agda", "-i", testpath/"lib/agda/src", stdlibtest

    # compile a simple module using the JS backend
    system bin/"agda", "--js", simpletest

    # test the GHC backend
    cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
    system "cabal", "v2-update"
    system "cabal", "install", "--lib", "base"
    system "cabal", "v2-install", "ieee754", "--lib", *cabal_args
    system "cabal", "v2-install", "text", "--lib", *cabal_args

    # compile and run a simple program
    system bin/"agda", "--ghc-flag=-fno-warn-star-is-type", "-c", iotest
    assert_equal "", shell_output(testpath/"IOTest")
  end
end