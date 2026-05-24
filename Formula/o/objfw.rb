class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.5.4.tar.gz"
  sha256 "7306dcf95bab8070efd1ff66791585b40c1826c109e280fb0db9a5d1cfb1384c"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2bccce015086a43019ee9c7215747e4f90ff6b2f723c6a511870aa68b3be2954"
    sha256 arm64_sequoia: "a735a23aab9b77ddf03067990447e945f60c11481647936752128c5ad961e95e"
    sha256 arm64_sonoma:  "bf4e2821e09446bc9cfc913dcd6ac3bea285f1db256d3ca88246894edfe587eb"
    sha256 sonoma:        "a880ebce18c6d4a4663fbe33d080a3dbcdd1a56dc68e1ad32901d46b29da3a4e"
    sha256 arm64_linux:   "c094407192f9898e66b9f05216cdcac47a6e17bb74e86a6f012e8a2547b8b84b"
    sha256 x86_64_linux:  "4ac5f08fe832f83de0c8c58c427660a0b44f269b422a356a1fbcb6de4c98e1b3"
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