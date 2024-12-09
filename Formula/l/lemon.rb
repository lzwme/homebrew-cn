class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2024/sqlite-src-3470200.zip"
  version "3.47.2"
  sha256 "e6a471f1238225f34c2c48c5601b54024cc538044368230f59ff0672be1fc623"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260cc38aebb3667c775e3c9e6d59a9a16d219093ed5d104b66b9279bc4fd0105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a524850f0a7bbcc06366a661688b1e36ef6247958837c6b388e393a7f8629a6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abba3d37ab374c6a75909602b45cac74fd139eca02bdae6d488d895c7d7f2a38"
    sha256 cellar: :any_skip_relocation, sonoma:        "b398efcb3389b2d70ce184076b01aa049615a77be405762b34853b450f1bf656"
    sha256 cellar: :any_skip_relocation, ventura:       "4858d1e7657e490f322712695d2d38810a7b30333536ccb7fd55e977c9ca838f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "272456d3190cdfbd85d26d87e155a05837cab8977195fce569ea896a7b6b855b"
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