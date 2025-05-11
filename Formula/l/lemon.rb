class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2025/sqlite-src-3490200.zip"
  version "3.49.2"
  sha256 "c3101978244669a43bc09f44fa21e47a4e25cdf440f1829e9eff176b9a477862"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d2a76e2c08439261c82871c9f07dda15a0c3eb49630ff32722a76ecbdfe6544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "281a30a1db4b546955430194d7b4875adb0b0b645c089f2bdc4eaefc4553dbb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e8b103446b7650c049ce821232303b5fc628e4f17753162d3ed5c22ed757c81"
    sha256 cellar: :any_skip_relocation, sequoia:       "acf3a9e67f1831df7b4ef3b2964c864d3a2f69c7101dfdbac049eb8fd2e3c727"
    sha256 cellar: :any_skip_relocation, sonoma:        "9362506ffa703973a49a3a8d9f5ff2d4b3fd1c50d18db55c9508ae96499a7d5f"
    sha256 cellar: :any_skip_relocation, ventura:       "6c80e973fc996f2f054c9e86ba23590a01496e2ba863a34e72eba8227f578b08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b29791edc131d0ea499c79cb006a49a40fbb1fdb998d74c6fcb2719ccf1e3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051ffd81a05525589d6b28b14a049dca4fb4f5e8f3ee0bff7764e47e809213cd"
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