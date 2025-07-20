class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2025/sqlite-src-3500300.zip"
  version "3.50.3"
  sha256 "119862654b36e252ac5f8add2b3d41ba03f4f387b48eb024956c36ea91012d3f"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b155a67759021db2959d2a8e7ab07aa252be5d7c1b2cf93caad7f55344c8bfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e165117245a381ef2303aed37172e9f96529950ba2c4e5a4ed4866e4fae1663a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f43eb1e7fc013395ca76956a55c5686324bcf61bb7bcbe379dc6215398cd956"
    sha256 cellar: :any_skip_relocation, sequoia:       "362d453f227e9f0dfca446990c52914d8fed38c0ed037b968d13f7a242006555"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e68b1d804761f6a658679233c49302a1388e7fe0d1baa026e8761315046a769"
    sha256 cellar: :any_skip_relocation, ventura:       "853e8b1d72cc6471f932308784d6da0192f2e3d70937fc7f12298f11d95e142c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "031629bbf5870f2ea380bbc9462ac405507366979ba9a2134f7530d5d9c79c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2572a68b4f4a8ea0d1317eef96d36b05f9bbc6aa2ef7cbdc96f8b5fe3eea47e3"
  end

  # Submitted the patch via email to the upstream
  patch :DATA

  def install
    pkgshare.install "tool/lempar.c"

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    inreplace "tool/lemon.c", "lempar.c", "#{pkgshare}/lempar.c"

    system ENV.cc, "-o", "lemon", "tool/lemon.c"
    bin.install "lemon"

    pkgshare.install "test/lemon-test01.y"
    doc.install "doc/lemon.html"
  end

  test do
    system bin/"lemon", "-d#{testpath}", "#{pkgshare}/lemon-test01.y"
    system ENV.cc, "lemon-test01.c"
    assert_match "tests pass", shell_output("./a.out")
  end
end

__END__
diff --git a/test/lemon-test01.y b/test/lemon-test01.y
index 0fd514f..67a3752 100644
--- a/test/lemon-test01.y
+++ b/test/lemon-test01.y
@@ -54,8 +54,8 @@ all ::=  error B.
     Parse(&xp, 0, 0);
     ParseFinalize(&xp);
     testCase(200, 1, nSyntaxError);
-    testCase(210, 1, nAccept);
-    testCase(220, 0, nFailure);
+    testCase(210, 0, nAccept);
+    testCase(220, 3, nFailure);
     nSyntaxError = nAccept = nFailure = 0;
     ParseInit(&xp);
     Parse(&xp, TK_A, 0);
@@ -64,7 +64,7 @@ all ::=  error B.
     ParseFinalize(&xp);
     testCase(200, 1, nSyntaxError);
     testCase(210, 0, nAccept);
-    testCase(220, 0, nFailure);
+    testCase(220, 2, nFailure);
     if( nErr==0 ){
       printf("%d tests pass\n", nTest);
     }else{