class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.2.2.tar.gz"
  sha256 "4fe0bed1ec21561a184d804aa577ff630f1e3d20b1c3b973073e23ce829294a1"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e8bb4b06978acbc2b805cbe029a8879f0b9ee9f8e1b0030b110679f747178712"
    sha256 arm64_sonoma:  "a2687a87f9b144627de5239ce77fea8c4626dc5ac480102dccb94be6084f18bf"
    sha256 arm64_ventura: "0c5e7f067ded31b848e957ddfdbb1fb435e449c4cb8e2d582550f1364aee31cf"
    sha256 sonoma:        "53c847cab22177ec96618a7f2e7d7a0296fb86e319920967c77f7c3397d8beb4"
    sha256 ventura:       "fe7fa6ecb130b61add83669621a2cdbc93742196a25b18d1521ebc074de945db"
    sha256 x86_64_linux:  "31e6692c676cf1e73572ea764dadc3e755b51d3c80e91e0b196c7c7c6ad572c3"
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