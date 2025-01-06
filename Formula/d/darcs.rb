class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "https://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.18.4/darcs-2.18.4.tar.gz"
  sha256 "f4bc276f2f785c8f8c9bcf97288f124a4e907540140213fe47b1049e2d240338"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ab51d3124d6071463a5e68555cb466acc9411a8962450abf3ebdd23272a3a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16c95a9b58eb5f73267878a640c60efe5265aaebe46a5b50a088a6cc58771964"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1109f1290bde12f969e687acb3eeaecb167eb6ab53a88c2f2bcaa1e170243ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d72e2013f16f2b4c07b3f73bebc8576d412bd9d505ecc27f2a8d3d633ec7269"
    sha256 cellar: :any_skip_relocation, ventura:       "3fee618610376d14ced94634aa36472da02617369051d6e3e33de74a7b6f5f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84301f6b1449333210b9c3ae435e09f83e7967c5d33761c089186426c9d834de"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "gmp"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Backport fixes for newer GHC[^1] and Cabal[^2]. Darcs uses a different
  # patch file format and cannot be applied with the external patch DSL.
  #
  # * darcs diff --hash 32646b190e019de21a103e950c4eccdd66f7eadc
  # * darcs diff --hash 50d9b0b402a896c83aa7929a50a0e0449838600f
  # * darcs diff --hash 8da98f5de14034aa79a2860212fa34e99585e188
  #
  # [^1]: https://bugs.darcs.net/patch2422
  # [^2]: https://bugs.darcs.net/patch2426
  patch :DATA

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    mkdir "my_repo" do
      system bin/"darcs", "init"
      Pathname("foo").write "hello homebrew!"
      system bin/"darcs", "add", "foo"
      system bin/"darcs", "record", "-am", "add foo", "--author=homebrew"
    end
    system bin/"darcs", "get", "my_repo", "my_repo_clone"
    assert_equal "hello homebrew!", (testpath/"my_repo_clone/foo").read
  end
end

__END__
diff -rN -u old-darcs.net/darcs.cabal new-darcs.net/darcs.cabal
--- old-darcs.net/darcs.cabal	2025-01-05 10:09:26
+++ new-darcs.net/darcs.cabal	2025-01-05 10:09:26
@@ -123,7 +123,7 @@
 -- ----------------------------------------------------------------------
 
 custom-setup
-    setup-depends: base      >= 4.10 && < 4.20,
+    setup-depends: base      >= 4.10 && < 4.21,
                    Cabal     >= 2.4 && < 3.11,
                    process   >= 1.2.3.0 && < 1.7,
                    filepath  >= 1.4.1 && < 1.5.0.0,
@@ -412,7 +412,7 @@
     else
       build-depends:  unix >= 2.7.1.0 && < 2.9
 
-    build-depends:    base              >= 4.10 && < 4.20,
+    build-depends:    base              >= 4.10 && < 4.21,
                       safe              >= 0.3.20 && < 0.4,
                       stm               >= 2.1 && < 2.6,
                       binary            >= 0.5 && < 0.11,
diff -rN -u old-darcs.net/Setup.hs new-darcs.net/Setup.hs
--- old-darcs.net/Setup.hs	2025-01-05 10:24:34
+++ new-darcs.net/Setup.hs	2025-01-05 10:24:34
@@ -8,7 +8,7 @@
 import Distribution.Package ( packageVersion )
 import Distribution.Version( Version )
 import Distribution.Simple.LocalBuildInfo
-         ( LocalBuildInfo(..), absoluteInstallDirs )
+         ( LocalBuildInfo(..), absoluteInstallDirs, buildDir )
 import Distribution.Simple.InstallDirs (mandir, CopyDest (NoCopyDest))
 import Distribution.Simple.Setup
     (buildVerbosity, copyDest, copyVerbosity, fromFlag,
diff -rN -u old-darcs.net/darcs.cabal new-darcs.net/darcs.cabal
--- old-darcs.net/darcs.cabal	2025-01-05 10:24:34
+++ new-darcs.net/darcs.cabal	2025-01-05 10:24:34
@@ -124,7 +124,7 @@
 
 custom-setup
     setup-depends: base      >= 4.10 && < 4.21,
-                   Cabal     >= 2.4 && < 3.11,
+                   Cabal     >= 2.4 && < 3.13,
                    process   >= 1.2.3.0 && < 1.7,
                    filepath  >= 1.4.1 && < 1.5.0.0,
                    directory >= 1.2.7 && < 1.4
diff -rN -u old-darcs.net/darcs.cabal new-darcs.net/darcs.cabal
--- old-darcs.net/darcs.cabal	2025-01-05 10:13:57
+++ new-darcs.net/darcs.cabal	2025-01-05 10:13:57
@@ -464,9 +464,9 @@
     if impl(ghc >= 9.8)
       cpp-options:    -DHAVE_CRYPTON_CONNECTION
       build-depends:  crypton-connection >= 0.4 && < 0.5,
-                      data-default-class >= 0.1.2.0 && < 0.1.3,
+                      data-default      >= 0.7.1.3 && < 0.9,
                       http-client-tls   >= 0.3.5 && < 0.4,
-                      tls               >= 2.0.6 && < 2.1
+                      tls               >= 2.0.6 && < 2.2
     else
       -- cannot use crypton-connection >= 0.4, so
       -- constraining indirect dependency to work around problems
diff -rN -u old-darcs.net/src/Darcs/Util/HTTP.hs new-darcs.net/src/Darcs/Util/HTTP.hs
--- old-darcs.net/src/Darcs/Util/HTTP.hs	2025-01-05 10:13:57
+++ new-darcs.net/src/Darcs/Util/HTTP.hs	2025-01-05 10:13:57
@@ -46,7 +46,7 @@
     )
 
 #ifdef HAVE_CRYPTON_CONNECTION
-import Data.Default.Class ( def )
+import Data.Default ( def )
 import qualified Network.Connection as NC
 import Network.HTTP.Client.TLS
     ( mkManagerSettings