class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2025/sqlite-src-3500100.zip"
  version "3.50.1"
  sha256 "9090597773c60a49caebb3c1ac57db626fac4d97cb51890815a8b529a4d9c3dc"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c5ddb8c30d4a39fe59771806e224d50bd5f3fb65550e75fbcad5643ef1d7037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51a07f510177c4ec51f2ddb05219ceab5faabccc2fbb0c3a8e0b0f30b0db459d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84d408c3ecd8c0e847ea6581cf7132634128e908a5b7c7a88f2b99b21bd959b4"
    sha256 cellar: :any_skip_relocation, sequoia:       "f5738d1ae7da106c0cb30d06d7bd9e97eabccdafa8da6a2d713e3da909c8eb28"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3a48c1a54f4aa7dcb6de41b183e9562cfb5e5540e363336fc98071c3032bc0c"
    sha256 cellar: :any_skip_relocation, ventura:       "3b1cefea0686790e07fbb9ffa1e7f3bbb0d6f184cd84de124758b65287f5ece6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b05947c75fc65664e0c7a7cd74df4b6a49e4c38eee84c4b649b13899f41ee4d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd52d256b5112ee9c4d3385344fa92293b24142dc588e762a65c17c97af140ed"
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