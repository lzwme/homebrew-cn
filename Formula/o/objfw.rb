class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.2.1.tar.gz"
  sha256 "637fdeccae149cec236e62c5289450afad542fe930343918856e76594ab3fcfd"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "2d1bfe25dfaae2537e4cc0e26a2094b02087aafa060c4cbf164a10f1bedda2e5"
    sha256 arm64_sonoma:  "10b1a4f836b1fe398bde97b7b44c17196dea8cc4a781597b3de6f9309fd45e6e"
    sha256 arm64_ventura: "02bbeca0dc52ea43096f239061fc13ab1cd3e096aaa599c4f9559c717aaf71c8"
    sha256 sonoma:        "c672a22de49d0a67e4145f82e08b18ee59318d7eae95e87abb5233c23d1eb4ed"
    sha256 ventura:       "7d85c355fb692d1e7cda04aa0c4cf0d156987685a936f53e835b755b917222c8"
    sha256 x86_64_linux:  "a41eff9799f724c8fc305923dd99dc018fbdcbb4563bf46e81ebcb0506c78e6c"
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