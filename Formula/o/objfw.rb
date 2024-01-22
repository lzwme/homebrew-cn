class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.8.tar.gz"
  sha256 "935e08e296d6e409e9f7d972a04cfde82c96064d17576f36ce738d04db571c56"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "65769c9977613b23ce1aa2ccd5322a80e19763e5c508013caa30edf18a810d1d"
    sha256 arm64_ventura:  "185d622e752c35ce4fbb85b323186bf6e99ad6fba131356c985a496c2c191165"
    sha256 arm64_monterey: "2eb6d6d36850719f5f302e0a6e66aad8da670890789ef1fd5d9bdeb0dc0a6880"
    sha256 sonoma:         "f719ba9cea42cb593532abab25f1d5f1b4536e002df1a4d9357552110ab7a131"
    sha256 ventura:        "d1fc5058a5ecbc68177e736cfcaf1f33a2daa915acc84358bf3104a1cdb5bc52"
    sha256 monterey:       "b503646bcf1be0657d4e2c701d5d8cbefdcfc21b6e3948a9effb0eb0b80a43e0"
    sha256 x86_64_linux:   "a9a28b7b9793e2bcc6c1ecccdd40901e5644dd934a44bc53704ab737f178e044"
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