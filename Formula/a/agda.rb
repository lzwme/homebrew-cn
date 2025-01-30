class Agda < Formula
  desc "Dependently typed functional programming language"
  homepage "https:wiki.portal.chalmers.seagda"
  # agda2hs.cabal specifies BSD-3-Clause but it installs an MIT LICENSE file.
  # Everything else specifies MIT license and installs corresponding file.
  license all_of: ["MIT", "BSD-3-Clause"]
  revision 2

  stable do
    url "https:github.comagdaagdaarchiverefstagsv2.6.4.3-r1.tar.gz"
    sha256 "15a0ebf08b71ebda0510c8cad04b053beeec653ed26e2c537614a80de8b2e132"
    version "2.6.4.3"

    resource "stdlib" do
      url "https:github.comagdaagda-stdlibarchiverefstagsv2.1.tar.gz"
      sha256 "72ca3ea25094efa0439e106f0d949330414232ec4cc5c3c3316e7e70dd06d431"
    end

    resource "cubical" do
      url "https:github.comagdacubicalarchiverefstagsv0.7.tar.gz"
      sha256 "25a0d1a0a01ba81888a74dfe864883547dbc1b06fa89ac842db13796b7389641"
    end

    resource "categories" do
      # Use git checkout due to `git ls-tree` usage in Makefile
      url "https:github.comagdaagda-categories.git",
          tag:      "v0.2.0",
          revision: "aee4189dd86889ee14338875ff7f6a81f35379c2"

      # Backport support for stdlib 2.1
      patch do
        url "https:github.comagdaagda-categoriescommitac0d9d27a402305f6774a6343f7a21a229822168.patch?full_index=1"
        sha256 "50dc97c97898c825dd4c85fffc8452dc3e61a7871aa907d65b1711e5642c05fc"
      end
    end

    resource "agda2hs" do
      url "https:github.comagdaagda2hsarchiverefstagsv1.2.tar.gz"
      sha256 "e80ffc90ff2ccb3933bf89a39ab16d920a6c7a7461a6d182faa0fb6c0446dbb8"
    end
  end

  # The regex below is intended to match stable tags like `2.6.3` but not
  # seemingly unstable tags like `2.6.3.20230930`.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)*\.\d{1,3})$i)
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "4b97635a593e1b6c9cc86442bebf1965ab8044978d4a9b2beef8f72d19644f0e"
    sha256 arm64_sonoma:  "3a7273b7e8f396137877528655f277589aa099436b4b89d3c0d9b7410325c407"
    sha256 arm64_ventura: "374ba6e21398191f1777853e880ef1a4cd972052c9f7f9d06bc95a6e22f6d1bc"
    sha256 sonoma:        "1b5f5bc0d740c168e40cff9c407a34eedee29954dc9be47f4b400597498b73ee"
    sha256 ventura:       "af45d9a99fecc0242a489e0e56d2567204ce626916c045bca10d62b34de1452a"
    sha256 x86_64_linux:  "282d393806f0f432e5443baab37c57a231e14d0922d99d54b8cc40e5a04ce589"
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

  depends_on "cabal-install" => :build
  depends_on "emacs" => :build
  depends_on "ghc"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    agda2hs = buildpath"agda2hs"
    agdalib = lib"agda"
    cubicallib = agdalib"cubical"
    categorieslib = agdalib"categories"

    resource("agda2hs").stage agda2hs
    resource("stdlib").stage agdalib
    resource("cubical").stage cubicallib
    resource("categories").stage categorieslib

    # Backport part of https:github.comagdaagda-stdlibcommita78700653de116b1043ce5d80bbe99482a705ecc
    inreplace agdalib"agda-stdlib-utils.cabal", ( base .*) < 4\.21$, "\\1 < 4.22" if build.stable?

    (buildpath"cabal.project.local").write <<~HASKELL
      packages: . #{agda2hs}
      package Agda
        flags: +optimise-heavily
    HASKELL

    cabal_args = std_cabal_v2_args
    # Workaround for GHC 9.12 until official support is available
    # Issue ref: https:github.comagdaagdaissues7574
    cabal_args += %w[
      --allow-newer=Agda:base
      --allow-newer=agda2hs:base
      --allow-newer=agda2hs:filepath
    ]
    # Workaround for https:github.comagdaagdacommite11ae9875470aab7b68b98d9d9574e736dbcaddd
    if build.stable?
      odie "Remove allow-newer hashable workaround!" if version > "2.6.4.3"
      cabal_args << "--allow-newer=Agda:hashable"
    end
    # Reduce install size by dynamically linking to shared libraries in store-dir
    # TODO: Linux support, related issue https:github.comhaskellcabalissues9784
    cabal_args += %w[--enable-executable-dynamic --enable-shared] if OS.mac?

    # Expose certain packages for building and testing
    exposed_packages = %w[base ieee754 text directory]

    system "cabal", "v2-update"
    system "cabal", "--store-dir=#{libexec}", "v2-install", *exposed_packages, "--lib", *cabal_args
    system "cabal", "--store-dir=#{libexec}", "v2-install", ".", agda2hs, *cabal_args

    # Allow build scripts to find stdlib and just built agda binary
    Pathname("#{Dir.home}.configagdalibraries").write "#{agdalib}standard-library.agda-lib"
    ENV.prepend_path "PATH", bin

    # Generate documentation and interface files. We build without extra options
    # so generated interface files work on basic use case. Options like -Werror
    # will need re-generation: https:github.comagdaagdaissues5151
    system "make", "-C", agdalib, "listings", "AGDA_OPTIONS="
    system "make", "-C", cubicallib, "gen-everythings", "listings", "AGDA_FLAGS="
    system "make", "-C", categorieslib, "html", "OTHEROPTS="

    # Clean up references to Homebrew shims and temporary generated files
    rm_r("#{agdalib}dist-newstyle")

    # Move the agda2hs support library into place
    (agdalib"agda2hs").install agda2hs"lib", agda2hs"agda2hs.agda-lib"

    # Workaround to generate interface files for agda2hs based on
    # https:github.comagdaagda2hsblobmasternixdefault.nix#L12-L16
    agda2hs_imports = Dir.glob("***.agda", base: agdalib"agda2hslib").map do |path|
      "import #{path.delete_suffix(".agda").tr("", ".")}"
    end
    (agdalib"agda2hsEverything.agda").write <<~AGDA
      {-# OPTIONS --sized-types #-}
      module Everything where
      #{agda2hs_imports.join("\n")}
    AGDA
    cd agdalib"agda2hs" do
      system bin"agda", "--include-path=.", "Everything.agda"
    end

    # write out the example libraries and defaults files for users to copy
    (agdalib"example-libraries").write <<~TEXT
      #{opt_lib}agdastandard-library.agda-lib
      #{opt_lib}agdadocstandard-library-doc.agda-lib
      #{opt_lib}agdatestsstandard-library-tests.agda-lib
      #{opt_lib}agdacubicalcubical.agda-lib
      #{opt_lib}agdacategoriesagda-categories.agda-lib
      #{opt_lib}agdaagda2hsagda2hs.agda-lib
    TEXT
    (agdalib"example-defaults").write <<~TEXT
      standard-library
      cubical
      agda-categories
      agda2hs
    TEXT
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
    Pathname("#{Dir.home}.configagda").install_symlink opt_lib"agdaexample-libraries" => "libraries"
    Pathname("#{Dir.home}.configagda").install_symlink opt_lib"agdaexample-defaults" => "defaults"

    simpletest = testpath"SimpleTest.agda"
    simpletest.write <<~AGDA
      {-# OPTIONS --safe --without-K #-}
      module SimpleTest where

      infix 4 _≡_
      data _≡_ {A : Set} (x : A) : A → Set where
        refl : x ≡ x

      cong : ∀ {A B : Set} (f : A → B) {x y} → x ≡ y → f x ≡ f y
      cong f refl = refl
    AGDA

    stdlibtest = testpath"StdlibTest.agda"
    stdlibtest.write <<~AGDA
      module StdlibTest where

      open import Data.Nat
      open import Relation.Binary.PropositionalEquality

      +-assoc : ∀ m n o → (m + n) + o ≡ m + (n + o)
      +-assoc zero    _ _ = refl
      +-assoc (suc m) n o = cong suc (+-assoc m n o)
    AGDA

    cubicaltest = testpath"CubicalTest.agda"
    cubicaltest.write <<~AGDA
      {-# OPTIONS --cubical #-}
      module CubicalTest where

      open import Cubical.Foundations.Prelude
      open import Cubical.Foundations.Isomorphism
      open import Cubical.Foundations.Univalence
      open import Cubical.Data.Int

      suc-equiv : ℤ ≡ ℤ
      suc-equiv = ua (isoToEquiv (iso sucℤ predℤ sucPred predSuc))
    AGDA

    categoriestest = testpath"CategoriesTest.agda"
    categoriestest.write <<~AGDA
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
    AGDA

    iotest = testpath"IOTest.agda"
    iotest.write <<~AGDA
      module IOTest where

      open import Agda.Builtin.IO
      open import Agda.Builtin.Unit

      postulate
        return : ∀ {A : Set} → A → IO A

      {-# COMPILE GHC return = \\_ -> return #-}

      main : _
      main = return tt
    AGDA

    agda2hstest = testpath"Agda2HsTest.agda"
    agda2hstest.write <<~AGDA
      {-# OPTIONS --erasure #-}
      open import Haskell.Prelude

      _≤_ : {{Ord a}} → a → a → Set
      x ≤ y = (x <= y) ≡ True

      data BST (a : Set) {{@0 _ : Ord a}} (@0 lower upper : a) : Set where
        Leaf : (@0 pf : lower ≤ upper) → BST a lower upper
        Node : (x : a) (l : BST a lower x) (r : BST a x upper) → BST a lower upper

      {-# COMPILE AGDA2HS BST #-}
    AGDA

    agda2hsout = testpath"Agda2HsTest.hs"
    agda2hsexpect = <<~HASKELL
      module Agda2HsTest where

      data BST a = Leaf
                 | Node a (BST a) (BST a)

    HASKELL

    # typecheck a simple module
    system bin"agda", simpletest

    # typecheck a module that uses the standard library
    system bin"agda", stdlibtest

    # typecheck a module that uses the cubical library
    system bin"agda", cubicaltest

    # typecheck a module that uses the categories library
    system bin"agda", categoriestest

    # compile a simple module using the JS backend
    system bin"agda", "--js", simpletest

    # test the GHC backend;
    # compile and run a simple program
    system bin"agda", "--ghc-flag=-fno-warn-star-is-type", "--compile", iotest
    assert_empty shell_output(testpath"IOTest")

    # translate a simple file via agda2hs
    system bin"agda2hs", "--out-dir=#{testpath}", agda2hstest
    assert_equal agda2hsexpect, agda2hsout.read
  end
end