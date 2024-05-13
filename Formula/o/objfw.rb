class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.1.3.tar.gz"
  sha256 "e66ff27ac93c5747019aaa5c8a72b2e4508938e59b3ce08909e54e566ebb2e41"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "656da059db1a46db252169fecb182e22d97896871bce9bad5698ecb0b9738dca"
    sha256 arm64_ventura:  "c87cdee289e44e02bad5294398a57325110e32b07b2848eafde824197a7dc319"
    sha256 arm64_monterey: "eba60553a1ee653a830b222feafe1d0b80698c80ca2a6d4618e758be61f33556"
    sha256 sonoma:         "d37a9e5dbf83a8311bd2d8b766aa70c9ea335e16142388bc8331270209610b67"
    sha256 ventura:        "e9c3dce7f1494c7f11dd1e08e2b9d17d79b999ab46aeaba4cbf673ef599d6c29"
    sha256 monterey:       "ad68ee0d2f228188d5a68ff7ce980eb2e2906e73effee4b3b4991b68f46d9533"
    sha256 x86_64_linux:   "5bacb537a54fb87d27d7748e74c7adbf905c25575a7d87f75b57c06fdfaba5e2"
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