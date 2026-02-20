class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.4.4.tar.gz"
  sha256 "29be5ea5d6a9c34b9873a40091367eb0b75072d627e2508380c02c38cb60ca38"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "45f4f5d3227b081c1a2fe94ff70eab4e9e51f89075c6a113aeb99abf5b2b5a83"
    sha256 arm64_sequoia: "8f9fb867c93506b886f145c912f1c3598dca85af940a1309f72c31da5c623482"
    sha256 arm64_sonoma:  "73c9f9dc9f8c06802bec9dfde55e30190be8147f95c3fccb3bf84dd6f9a03a3f"
    sha256 sonoma:        "b9b86fb20abc1cd665af334cd236f203aff4b4c454f089223de30b171886c1c0"
    sha256 arm64_linux:   "dd1f5a5e1f0752c235ecc447ffa27345df2a59eaa3be95a9dd186eb1b2df9742"
    sha256 x86_64_linux:  "a33ee673da916e23f878ebe9b3556d2c0e0c0266e1e193091134108fe364f91d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "llvm"
    depends_on "openssl@3"
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