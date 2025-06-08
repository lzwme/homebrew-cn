class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.3.1.tar.gz"
  sha256 "a3bdf28c2e166f97680601c29f204670a8c4c8e43d393321a7d1f64fe1d2f513"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e72889618c308398315bed8f950b0204dc1d1b13f617688b7e4e68cc55fbbe28"
    sha256 arm64_sonoma:  "b92b445ba45a570948c1f994c362a1e007a15be73cb899d4c6bff65ab69c4d77"
    sha256 arm64_ventura: "f2269407984c284520cbaf76003e3b781c5e993754c33383b7a7ea80c0e18a62"
    sha256 sonoma:        "c0b882afc31b310be6a67c2d53f36b812b3011a20b34a74d41fcfa2f0cb33fa9"
    sha256 ventura:       "c9adc05a96dbf3a510afa4c7e23cd525f0f9b7ef2865f980f14c78227d8f244e"
    sha256 arm64_linux:   "e36af4104b44e9048db2be7383b50738ee5bd08f9a9efcaecf03a47eb59c8c06"
    sha256 x86_64_linux:  "dd48c8235b71203b0d344fe4437d3080c9b39c716ffc0a184cbb6cc43d84d80b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "llvm"
    depends_on "openssl@3"
    depends_on "zlib"
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
+			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,${prefix}/Library/Frameworks/$$out/$${out%.framework}'
 		])
 
 		AC_SUBST(FRAMEWORK_LDFLAGS)