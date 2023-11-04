class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2023/sqlite-src-3440000.zip"
  version "3.44.0"
  sha256 "ab9aae38a11b931f35d8d1c6d62826d215579892e6ffbf89f20bdce106a9c8c5"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "970069c0d5ddc5c05a9db47384f85340bef1996b347db0c7aff44a59b2d8739a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84e241d1cc4973b82d2de1f9e16ab2f3660b97660247bfe3998eb3456c49061a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "940b28c1560f18799a9c064363bc33aa64e8a1f05b6efc246929aae7d546f5b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "614701469e4667fbb2fabae7efc1b549cb4870d230cfe4afe95d86711aa52828"
    sha256 cellar: :any_skip_relocation, ventura:        "dd979104c90472e32d67d7aefe4f146738dd412e86912d91d260d06bc7a13acc"
    sha256 cellar: :any_skip_relocation, monterey:       "7c9bff1046c7fca0c8f89d20e95d0fdfbeaad2b7d73c3afd15dcc3d42bddd552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14701b17be4b0a8c7a4a065005fb37bcc5154c70ddea8e9aa066a66000118bad"
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