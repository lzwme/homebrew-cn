class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.2.tar.gz"
  sha256 "f1d92b64f524a1aaf8e8b572a0edf5817d589c3d3c60cab9bb182ccbac3ee405"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "47f3542d55c88fe3814fef0770059a2c5dafa9bed4060ee283bd13c4be17673b"
    sha256 arm64_sonoma:  "af3776fc09836185045ac1d9ac767945523f2150f3a66c5d62b08e04ff8da015"
    sha256 arm64_ventura: "02ce2d9299728f681bbb4bc8384c9879fe9b7274fc4b0218845d5bcf20400d75"
    sha256 sonoma:        "4c22f8dcc3753f8dffc12a95b3044c3d4f929e042e7132dec3e6f7db3cd90e58"
    sha256 ventura:       "786ae0a9259752bb37ea14211841552a3d1be9ac92baae042bfc66a1b0d65b23"
    sha256 x86_64_linux:  "df96821dd3276bc14fdc2452466255eb018ed8774521fa3071f1a856f46a6c3d"
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