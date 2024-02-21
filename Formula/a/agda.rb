class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https:wiki.portal.chalmers.seagda"
  license "BSD-3-Clause"
  revision 3

  stable do
    url "https:hackage.haskell.orgpackageAgda-2.6.4.1Agda-2.6.4.1.tar.gz"
    sha256 "23248a9b3c50c81ea4751518a66f2a6144617b6a5a9202686b54e33bc9cbd080"

    resource "stdlib" do
      url "https:github.comagdaagda-stdlibarchiverefstagsv2.0.tar.gz"
      sha256 "14eecb83d62495f701e1eb03ffba59a2f767491f728a8ab8c8bb9243331399d8"
    end

    resource "cubical" do
      url "https:github.comagdacubicalarchiverefstagsv0.6.tar.gz"
      sha256 "10b78aec56c4dfa24a340852153e305306e6a569c49e75d1ba7edbaaa6bba8e3"
    end

    resource "categories" do
      url "https:github.comagdaagda-categoriesarchiverefstagsv0.2.0.tar.gz"
      sha256 "a4bf97bf0966ba81553a2dad32f6c9a38cd74b4c86f23f23f701b424549f9015"
    end

    resource "agda2hs" do
      url "https:github.comagdaagda2hsarchiverefstagsv1.2.tar.gz"
      sha256 "e80ffc90ff2ccb3933bf89a39ab16d920a6c7a7461a6d182faa0fb6c0446dbb8"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "b147e908bfed75f2feaac939820186790f2f2d57d5e5e025579e6c466c910fda"
    sha256 arm64_ventura:  "552bd32ee1afe760253bc18431a93588617e82ac92cd673023fdd360a29b1f17"
    sha256 arm64_monterey: "4b89efee0415fb0ad6ab7d4712088abf8143266f17ba8cf3e35ca893a3a221b6"
    sha256 sonoma:         "b22dec07b7bc473e3bfe0bfcf0284ce88e731e4db06b3fdf6ef6cee5894966ea"
    sha256 ventura:        "9b3fd6602afe23470f9f655b6e410fd0d63dccd5bd4081acddb70f30f6757c57"
    sha256 monterey:       "ecd8bb5986e56385d81f8fbe06ddb487f736bc0eaf9753b81e96b3ad8c3ef300"
    sha256 x86_64_linux:   "dc51a274435bbab8f8494a8bda9fd8795a4acb4d6949a671b939483805614509"
  end

  head do
    url "https:github.comagdaagda.git", branch: "master"

    resource "stdlib" do
      url "https:github.comagdaagda-stdlib.git", branch: "master"
    end

    resource "cubical" do
      url "https:github.comagdacubical.git", branch: "master"
    end

    resource "categories" do
      url "https:github.comagdaagda-categories.git", branch: "master"
    end

    resource "agda2hs" do
      url "https:github.comagdaagda2hs.git", branch: "master"
    end
  end

  depends_on "cabal-install"
  depends_on "emacs"
  depends_on "ghc"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    # expose certain packages for building and testing
    system "cabal", "--store-dir=#{libexec}", "v2-install",
           "base", "ieee754", "text", "directory", "--lib",
           *(std_cabal_v2_args.reject { |s| s["installdir"] })
    agdalib = lib"agda"

    # install main Agda library and binaries
    system "cabal", "--store-dir=#{libexec}", "v2-install",
    "-foptimise-heavily", *std_cabal_v2_args

    # install agda2hs helper binary and library,
    # relying on the Agda library just installed
    resource("agda2hs").stage "agda2hs-build"
    cd "agda2hs-build" do
      system "cabal", "--store-dir=#{libexec}", "v2-install", *std_cabal_v2_args
    end

    # generate the standard library's documentation and vim highlighting files
    resource("stdlib").stage agdalib
    cd agdalib do
      cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
      system "cabal", "v2-update"
      system "cabal", "--store-dir=#{libexec}", "v2-install", *cabal_args, "--installdir=#{lib}agda"
      system ".GenerateEverything"
      cd "doc" do
        system bin"agda", "-i", "..", "--html", "--vim", "README.agda"
      end
    end

    # Clean up references to Homebrew shims in the standard library
    rm_rf "#{agdalib}dist-newstylecache"

    # generate the cubical library's documentation files
    cubicallib = agdalib"cubical"
    resource("cubical").stage cubicallib
    cd cubicallib do
      system "make", "gen-everythings", "listings",
             "AGDA_BIN=#{bin"agda"}",
             "RUNHASKELL=#{Formula["ghc"].bin"runhaskell"}"
    end

    # generate the categories library's documentation files
    categorieslib = agdalib"categories"
    resource("categories").stage categorieslib
    cd categorieslib do
      # fix the Makefile to use the Agda binary and
      # the standard library that we just installed
      inreplace "Makefile",
                "agda ${RTSARGS}",
                "#{bin}agda --no-libraries -i #{agdalib}src ${RTSARGS}"
      system "make", "html"
    end

    # move the agda2hs support library into place
    (agdalib"agda2hs").install "agda2hs-buildlib",
                                "agda2hs-buildagda2hs.agda-lib"

    # write out the example libraries and defaults files for users to copy
    (agdalib"example-libraries").write <<~EOS
      #{opt_lib}agdastandard-library.agda-lib
      #{opt_lib}agdadocstandard-library-doc.agda-lib
      #{opt_lib}agdatestsstandard-library-tests.agda-lib
      #{opt_lib}agdacubicalcubical.agda-lib
      #{opt_lib}agdacategoriesagda-categories.agda-lib
      #{opt_lib}agdaagda2hsagda2hs.agda-lib
    EOS
    (agdalib"example-defaults").write <<~EOS
      standard-library
      cubical
      agda-categories
      agda2hs
    EOS
  end

  def caveats
    <<~EOS
      To use the installed Agda libraries, execute the following commands:

          mkdir -p $HOME.configagda
          cp #{opt_lib}agdaexample-libraries $HOME.configagdalibraries
          cp #{opt_lib}agdaexample-defaults $HOME.configagdadefaults

      You can then inspect the copied files and customize them as needed.
    EOS
  end

  test do
    simpletest = testpath"SimpleTest.agda"
    simpletest.write <<~EOS
      {-# OPTIONS --safe --without-K #-}
      module SimpleTest where

      infix 4 _≡_
      data _≡_ {A : Set} (x : A) : A → Set where
        refl : x ≡ x

      cong : ∀ {A B : Set} (f : A → B) {x y} → x ≡ y → f x ≡ f y
      cong f refl = refl
    EOS

    stdlibtest = testpath"StdlibTest.agda"
    stdlibtest.write <<~EOS
      module StdlibTest where

      open import Data.Nat
      open import Relation.Binary.PropositionalEquality

      +-assoc : ∀ m n o → (m + n) + o ≡ m + (n + o)
      +-assoc zero    _ _ = refl
      +-assoc (suc m) n o = cong suc (+-assoc m n o)
    EOS

    cubicaltest = testpath"CubicalTest.agda"
    cubicaltest.write <<~EOS
      {-# OPTIONS --cubical #-}
      module CubicalTest where

      open import Cubical.Foundations.Prelude
      open import Cubical.Foundations.Isomorphism
      open import Cubical.Foundations.Univalence
      open import Cubical.Data.Int

      suc-equiv : ℤ ≡ ℤ
      suc-equiv = ua (isoToEquiv (iso sucℤ predℤ sucPred predSuc))
    EOS

    categoriestest = testpath"CategoriesTest.agda"
    categoriestest.write <<~EOS
      module CategoriesTest where

      open import Level using (zero)
      open import Data.Empty
      open import Data.Quiver
      open Quiver

      empty-quiver : Quiver zero zero zero
      Obj empty-quiver = ⊥
      _⇒_ empty-quiver ()
      _≈_ empty-quiver {()}
      equiv empty-quiver {()}
    EOS

    iotest = testpath"IOTest.agda"
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

    agda2hstest = testpath"Agda2HsTest.agda"
    agda2hstest.write <<~EOS
      {-# OPTIONS --erasure #-}
      open import Haskell.Prelude

      _≤_ : {{Ord a}} → a → a → Set
      x ≤ y = (x <= y) ≡ True

      data BST (a : Set) {{@0 _ : Ord a}} (@0 lower upper : a) : Set where
        Leaf : (@0 pf : lower ≤ upper) → BST a lower upper
        Node : (x : a) (l : BST a lower x) (r : BST a x upper) → BST a lower upper

      {-# COMPILE AGDA2HS BST #-}
    EOS

    agda2hsout = testpath"Agda2HsTest.hs"
    agda2hsexpect = <<~EOS
      module Agda2HsTest where

      data BST a = Leaf
                 | Node a (BST a) (BST a)

    EOS

    # we need a test-local copy of the stdlib as the test writes to
    # the stdlib directory; the same applies to the cubical,
    # categories, and agda2hs libraries
    resource("stdlib").stage testpath"libagda"
    resource("cubical").stage testpath"libagdacubical"
    resource("categories").stage testpath"libagdacategories"
    resource("agda2hs").stage testpath"libagdaagda2hs"

    # typecheck a simple module
    system bin"agda", simpletest

    # typecheck a module that uses the standard library
    system bin"agda",
           "-i", testpath"libagdasrc",
           stdlibtest

    # typecheck a module that uses the cubical library
    system bin"agda",
           "-i", testpath"libagdacubical",
           cubicaltest

    # typecheck a module that uses the categories library
    system bin"agda",
           "-i", testpath"libagdacategoriessrc",
           "-i", testpath"libagdasrc",
           categoriestest

    # compile a simple module using the JS backend
    system bin"agda", "--js", simpletest

    # test the GHC backend;
    # compile and run a simple program
    system bin"agda", "--ghc-flag=-fno-warn-star-is-type", "-c", iotest
    assert_equal "", shell_output(testpath"IOTest")

    # translate a simple file via agda2hs
    system bin"agda2hs", agda2hstest,
           "-i", testpath"libagdaagda2hslib",
           "-o", testpath
    agda2hsactual = File.read(agda2hsout)
    assert_equal agda2hsexpect, agda2hsactual
  end
end