class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2023/sqlite-src-3440100.zip"
  version "3.44.1"
  sha256 "52aa53c59ec9be4c28e2d2524676cb2938558f11c2b4c00d8b1a546000453919"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c7c36f1fc8d1484d1407510ec59888f8da749608c23e27055f646b4f06b4a12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74b9f939545b1607176d0feb0919963ee0f0c0dfc60312b14dbc5f8c499f926a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbd54ff6f4380d9b4fdde79ec91160fdf1b5b8247e929fe2e81e9dfda88ac10d"
    sha256 cellar: :any_skip_relocation, sonoma:         "154770c3e3f18def3b87030d7eb81a19e3301e439bf7a1a14b966fdc64fdfc3c"
    sha256 cellar: :any_skip_relocation, ventura:        "d0b0b1bc5a5284ed1641b268919d4164cbb8437a9a0271ce1e3508367d38124b"
    sha256 cellar: :any_skip_relocation, monterey:       "78eef54b35700d4b2cc49d7559ae1582f1d84c043026d183147186bb41a2b674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e517b3de740f42cd5bcf48cdfe33162f163bc038edab484b1a662be7f275c64c"
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