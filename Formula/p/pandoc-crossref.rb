class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https:github.comlierdakilpandoc-crossref"
  url "https:github.comlierdakilpandoc-crossrefarchiverefstagsv0.3.17.1c.tar.gz"
  version "0.3.17.1c"
  sha256 "1c1d00d356c74749d530b508db2e6aca6fe9f5ae3a283af58d25bedc99293977"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71ab252eb7085e2272e0f398c5340e6b5157369ea797d470d9e5d36d83bc5aee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b78dce0feb4a6e9c476146872b4de34e6020085c2132d1b8a345fb8dd0ae0984"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1df76d3945be8f57b169749496520b1adc069136f0c5df3a7a17e08f8b4eb19"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f8415033188e12f8bb1c2651a12cd5ba8090e8547c68e96ebbfa5599c14cdb8"
    sha256 cellar: :any_skip_relocation, ventura:       "9d414e12b5c71f74c85f6961b7cded015c3271db920bd343f2e0c17e77c84ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e81485d495af9d118afb20f8ecfb014a5553847dbad7c12abd50772e599dcb8d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  # build patch to support pandoc 3.4, upstream PR ref: https:github.comlierdakilpandoc-crossrefpull451
  patch :DATA

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    output = shell_output("#{Formula["pandoc"].bin}pandoc -F #{bin}pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end

__END__
diff --git apackage.yaml bpackage.yaml
index ab2ac81..c06adac 100644
--- apackage.yaml
+++ bpackage.yaml
@@ -20,7 +20,7 @@ data-files:
 dependencies:
   base: ">=4.11 && <5"
   text: ">=1.2.2 && <2.2"
-  pandoc: ">=3.1.8 && < 3.4"
+  pandoc: ">=3.1.8 && < 3.5"
   pandoc-types: ">= 1.23 && < 1.24"
 _deps:
   containers: &containers { containers: ">=0.1 && <0.7" }
diff --git apandoc-crossref.cabal bpandoc-crossref.cabal
index 0fc730b..3ff1a2b 100644
--- apandoc-crossref.cabal
+++ bpandoc-crossref.cabal
@@ -1,6 +1,6 @@
 cabal-version: 2.0
 
--- This file has been generated from package.yaml by hpack version 0.36.0.
+-- This file has been generated from package.yaml by hpack version 0.37.0.
 --
 -- see: https:github.comsolhpack
 
@@ -133,7 +133,7 @@ library
   build-depends:
       base >=4.11 && <5
     , mtl >=1.1 && <2.4
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-crossref-internal
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
@@ -177,7 +177,7 @@ library pandoc-crossref-internal
     , microlens-mtl >=0.2.0.1 && <0.3.0.0
     , microlens-th >=0.4.3.10 && <0.5.0.0
     , mtl >=1.1 && <2.4
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-types ==1.23.*
     , syb >=0.4 && <0.8
     , template-haskell >=2.7.0.0 && <3.0.0.0
@@ -198,7 +198,7 @@ executable pandoc-crossref
     , gitrev >=1.3.1 && <1.4
     , open-browser ==0.2.*
     , optparse-applicative >=0.13 && <0.19
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , template-haskell >=2.7.0.0 && <3.0.0.0
@@ -219,7 +219,7 @@ test-suite test-integrative
     , directory >=1 && <1.4
     , filepath >=1.1 && <1.6
     , hspec >=2.4.4 && <3
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
@@ -245,7 +245,7 @@ test-suite test-pandoc-crossref
     , hspec >=2.4.4 && <3
     , microlens >=0.4.12.0 && <0.5.0.0
     , mtl >=1.1 && <2.4
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-crossref
     , pandoc-crossref-internal
     , pandoc-types ==1.23.*
@@ -265,7 +265,7 @@ benchmark simple
   build-depends:
       base >=4.11 && <5
     , criterion >=1.5.9.0 && <1.7
-    , pandoc >=3.1.8 && <3.4
+    , pandoc >=3.1.8 && <3.5
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2