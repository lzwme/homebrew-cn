class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2026/sqlite-src-3520000.zip"
  version "3.52.0"
  sha256 "652a98ca833ed638809a52bec225a7f37799f71a995778f9ccb68ad03bd1fc11"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4a374712075d4afc63f969bb0caeb810d27d57a209415220ff08ace9e233289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e8ac61ac4ace1d34d4c875ff59e60ea6de66109795e69471390f8eeedfb1614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29126702c069c921b051bda4057b8aba1e6c1f0b1e33e88f0cdbf3f1d40ce8f2"
    sha256 cellar: :any_skip_relocation, tahoe:         "fc620ddd515c2ce47d1e2ad89cea246200f5d83f4d1503f274d2fce5260f7b52"
    sha256 cellar: :any_skip_relocation, sequoia:       "f617a098f72ef7ddf5c554b129a7ec8e52249a1bdb5cc89af4b5c74891182cbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a5d8aa8fd22d02fa8ba36754205fd96d9c20194c14843cae2fec3815664c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f5de7cfb10c1e59aa7c55da1192ef0c9fbc86c128a7cc2d4357de7366c4db81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "604eb0a04c87eb88628c630abcf7130190191a21a84cc6bf808f1f7017e3c002"
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