class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.1.5.tar.gz"
  sha256 "9d45d2009a0bb9b1a0918918e454b47b8161670df8016b5f3a85eccea91d8988"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6f16015b6c32e9de4d84855647117f3a2f74f74b2f24828a99d45bbf4e7153c4"
    sha256 arm64_ventura:  "d078bacc667a7183f1c12079cd880ddb8db1050967d762a36e0343bb618d8102"
    sha256 arm64_monterey: "e8f5fbc918bd805a9176ae994190f67521a469b25f8840f84bc016dfe283bce6"
    sha256 sonoma:         "8c9ed071395c1bd1079fdbeb567afbcfb3323fa859d979455c32a364ff898b1c"
    sha256 ventura:        "8b5fa0cc92ba275f8f8e993c4d7d76806d5159bed8cdf9d5ba23b93bac174e3d"
    sha256 monterey:       "5abefcda2e911c206a82949bcf13199f365b1bc35b3f0e5e66769dd8c2254b63"
    sha256 x86_64_linux:   "11e9e2b6b89d1de0c3a25e0e5b9d7f98db3b3c6cf1faf4541431a88fc7e4fa3e"
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