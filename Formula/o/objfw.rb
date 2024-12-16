class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.2.3.tar.gz"
  sha256 "8324d3b352121544f817f40f71c21005457ee0255104c7e0d5aedbd6d968bced"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c785afb5e54db955b9fd9e9598f4b198e96ee2aabfe1665032f929a211766fd0"
    sha256 arm64_sonoma:  "89f9db735e6412a17544e33e5861e0c4003c6b9edc1023d1d89ca924749de4d1"
    sha256 arm64_ventura: "3da338e5f0da0e566d6602405288990a8568f9b9980a003e425cc362dd512213"
    sha256 sonoma:        "5a25b57dc213a81115efa33ca6b416f4efbc93e5fb810d96ec5ab2408777fe98"
    sha256 ventura:       "25660773d6b8c140fd9ef70db699480e84da3362dc47d72386e710f9879b54d3"
    sha256 x86_64_linux:  "573866fbd8268324845b7e03f88fb90a57b6f914b99e622226e365fd64ed9fa3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "llvm"
    depends_on "openssl@3"
  end

  fails_with :gcc

  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    inreplace bin/"objfw-config", "llvm_clang", "clang" if OS.linux?
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
+			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,${prefix}/Library/Frameworks/$$out/$${out%.framework}'
 		])
 
 		AC_SUBST(FRAMEWORK_LDFLAGS)