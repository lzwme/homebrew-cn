class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2024/sqlite-src-3450000.zip"
  version "3.45.0"
  sha256 "14dc2db487e8563ce286a38949042cb1e87ca66d872d5ea43c76391004941fe2"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0694287c4c40d524cbe506eb69d759a978d91ce5ae8f3d3798fbc4107220fbf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63886ffdb43451d4faa0b7fdd4de1c4d9bd52125f67a3b9249c193244e2275a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26e779f021d5bb36f0928799140b684bad51f80e32426377d94c2ed7b637d619"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4cc880d6c015b60ead5ca9712a89ae302becbadc9ef6e0e549dacbb2d1c339f"
    sha256 cellar: :any_skip_relocation, ventura:        "0a7cc165de67ddefeaacdce5943525b668c125a68e19712bbeb879cd4a456f35"
    sha256 cellar: :any_skip_relocation, monterey:       "c22476a46aa5324986efdb0de7917e26de0460a7da4bbc5aed8d5312b902f881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ee5369738d571b22acb7713a65b931bc6b0c05791e03dab370a9758e3f16e4e"
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