class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2025/sqlite-src-3490000.zip"
  version "3.49.0"
  sha256 "bec0262d5b165b133d6f3bdb4339c0610f4ac3d50dee53e8ad148ece54a129d0"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "231db7d63003b8f584e2be73afa90314506609aac21bfeb5b8ba51667ebb8ff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70fb8aae48eddea4a7925f7c043fd81685b102686e60499258c94ee714e48ce3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69dc4426cb90323179dfd45d1324247677d78b0f9b626470433d686c8fd57e5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f73d4d3638c09d687182a987b786a651f03815bd2d58252c3d226878a52502cd"
    sha256 cellar: :any_skip_relocation, ventura:       "598c7dc04e6bd0304cad85c9d9ab252ac70c4d1ff673bf214d587c27034dd7b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c429bc81b16f4a6afd25892df4a4322c0331ae21db65ecc6e6aa7eba7f215212"
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