class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.2.tar.gz"
  sha256 "b680be08bfade376d17958f3ceadaf223ac5d08df71a4bd787a42640a86db7cb"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5f9e130a4db63c71ceb696296cd98f02e797cbad36994eb42ca95db4a55f43d5"
    sha256 arm64_monterey: "3e547bbb189d499397ba70cc03ab4a9b31d6f926f0826a79781a2bb81cd32231"
    sha256 arm64_big_sur:  "31564033be5b7994c8073c91274566d738271f9ed6f0a41da1a6db87f6aa2328"
    sha256 ventura:        "40d2cdebbaee54071986e3d81fa6f4080329197f8f42d02ff671143b380f9b62"
    sha256 monterey:       "456d5f6aac9f0b24a0edb16dbb9bb8f075c2df08baf6babda3905475f71ad8b7"
    sha256 big_sur:        "e1a28ec274942800d95b2a767308314957c91165526959cb7d423ad0f8a43f5c"
    sha256 x86_64_linux:   "675b427ab64b1ba29edec26fb40d7942eeb8c754f8f31e8a5d6de8223d55adae"
  end

  head do
    url "https://github.com/ObjFW/ObjFW.git", branch: "master"
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