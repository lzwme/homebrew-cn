class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2023/sqlite-src-3440200.zip"
  version "3.44.2"
  sha256 "73187473feb74509357e8fa6cb9fd67153b2d010d00aeb2fddb6ceeb18abaf27"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de8c4408b82155488658bbeba6a8bf4f2df7060267a107bce59825bdf6895c95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5adb87e06354e002120d56fc6c04cc3669ef7b88dc4c6e86d7d99affacb273dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6366002da4b9ba137ee43fd441b912bb2ede7a59a56e5033eb320e20e663063b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccc4aeb46f24c671648a96dcf8b28fed97b7ad5b5fdd47c66a518e61ee239a00"
    sha256 cellar: :any_skip_relocation, ventura:        "7bd0b735a864f963a28609615b770c02d0f5b54fd803c0abc1874abaca137fc4"
    sha256 cellar: :any_skip_relocation, monterey:       "bf313e7998d9f292a739a5405a80d90f46f55478dc06355bf9f888cff02f90d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dbb0f11361600f0a912012e4b34f683671a47b353b113b795b0b66ad7d78e00"
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
    system "#{bin}/lemon", "-d#{testpath}", "#{pkgshare}/lemon-test01.y"
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