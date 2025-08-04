class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.4.tar.gz"
  sha256 "3704b5bf2f27b9327be8e3b8f87745b9cf37c5d3d1e957600617023ee2b3eb12"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "86e7e6130711aebfeb0c1c7aafb24349acfadfd54760a6979f6f059a65968361"
    sha256 arm64_sonoma:  "bee322862beaeafc2c9e569538317d6e6e6c80ca4ed37c7ec86438d15ce5446b"
    sha256 arm64_ventura: "9bb2d9b87ac886f0036cd06dcd28d876a10982097062c9c7bf6ebf49dab80b4b"
    sha256 sonoma:        "dbb608d8d478098aa8ce781c44ff48692a7c386c9f8dd756eeb238407a90b23d"
    sha256 ventura:       "8bb7447255776f03f088ed7e6b5fd5b8e6d577966841d1411f309b1caf6da505"
    sha256 arm64_linux:   "97d613d03e102daa81e07ccc80515f4b1c007319b584999f61ffd4f47eb72125"
    sha256 x86_64_linux:  "ac63ee17459b269a5b7d63bd07ad8313a1838f87fcae251fd4c8743f31393fb6"
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
+			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@loader_path/../../../$$out/$${out%.framework}'
 		])
 
 		AC_SUBST(FRAMEWORK_LDFLAGS)