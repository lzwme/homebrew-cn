class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.6.tar.gz"
  sha256 "34eb6ee5be84d86a3de657ab17c9ee79fcfc8b3dc0d21f72917aa92378948d73"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f439fa294de7b597433deca694294294697ae1745753bfc6f25e87f461e10125"
    sha256 arm64_ventura:  "683bc8e62a2c3eb21be1a7c56e81c90e818c20c999d33864313447b63ec2978a"
    sha256 arm64_monterey: "09f21a43ecd502158c52b7b7969c3ecc90ef4300d3894b36b037c13c6202b4c6"
    sha256 sonoma:         "870ca82a4a46520a0f8532b9f393165c9f892674389985eeda537b23ccdee80d"
    sha256 ventura:        "b12e2fef167885fee78abacf3eafe082c69fc3cd6a40e2c3d9145f9dc7683bfa"
    sha256 monterey:       "cc151c98b66f4a6236f3d272d59001dc6a401cf64e71b89763d3734524261d4f"
    sha256 x86_64_linux:   "6482b970be79a3d3db4a91ae84001130d7f3cbee2a50ca1e0a32209c2c0b9c44"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "llvm"
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
    system "#{bin}/objfw-new", "--app", "Test"
    system "#{bin}/objfw-compile", "-o", "t", "Test.m"
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