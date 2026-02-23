class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.5.tar.gz"
  sha256 "438f18ea760b081bdfcb2b3829c62b8645d241dde08d65a8c004ee4f6b56d9f4"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0dac7204a2d1e18059d2a2440579ca254a5476f60311fb38b8c34948e371383d"
    sha256 arm64_sequoia: "08d063713b71cf665cd69fb559ef0a4a385d9d7a291429b9231985130b0aa058"
    sha256 arm64_sonoma:  "16d31e746dd0a581cc6744137ed003c4a9b27c6a64c0a768efef914c73374f16"
    sha256 sonoma:        "fc0c0e7d4f63f07f7300d9b4a89098a963948373f4f2842afc830e7d39b74c1a"
    sha256 arm64_linux:   "8870be517ebe91584a7ee2f23c22cf1bd70fac62cdefe1232299d0f7d5844449"
    sha256 x86_64_linux:  "bcf37b84490b09fe107563e89dc77f551fddf956fe89905898092eb38c441174"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "llvm"
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc

  patch :DATA

  def install
    ENV.clang if OS.linux?

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    return unless OS.mac?

    inreplace bin/"objfw-config", 'OBJC="clang"', 'OBJC="/usr/bin/clang"'
  end

  test do
    system bin/"objfw-new", "--app", "Test"
    system bin/"objfw-compile", "-o", "t", "Test.m"
    system "./t"
  end
end

__END__
diff --git a/build-aux/m4/buildsys.m4 b/build-aux/m4/buildsys.m4
index 3ec1cc5c..c0c31cac 100644
--- a/build-aux/m4/buildsys.m4
+++ b/build-aux/m4/buildsys.m4
@@ -323,7 +323,7 @@ AC_DEFUN([BUILDSYS_FRAMEWORK], [
 		AS_IF([test x"$host_is_ios" = x"yes"], [
 			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/Frameworks/$$out/$${out%.framework}'
 		], [
-			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/../Frameworks/$$out/$${out%.framework}'
+			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@loader_path/../../../$$out/$${out%.framework}'
 		])
 
 		AC_SUBST(FRAMEWORK_LDFLAGS)