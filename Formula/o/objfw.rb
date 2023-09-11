class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.1.tar.gz"
  sha256 "953fd8a7819fdbfa3b3092b06ac7f43a74bac736c120a40f2e3724f218d215f1"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d3c3b5581d03ec4e98be3493fdf6e612eacfa8de6e9d6621ddababd45f6e1649"
    sha256 arm64_monterey: "99bd64c40550a77d46b94f80702b5ea4a23d06d602b851ce2912f306ed746aed"
    sha256 arm64_big_sur:  "8b8309305bc3752ea58f7e46d4145c70518f11bd8e269708cb1cc7ef97fa914f"
    sha256 ventura:        "f9a8bc67b44b0a383edb9f19c9eee72d69ac19f3444b54f646edfa0c4b9abfdf"
    sha256 monterey:       "e4c3c34888fb08c99f3d45e71858641e50ba56b55596fdb69f18e680afd4546d"
    sha256 big_sur:        "a725b773d836fd29b3ac590060037360f9851ad4464a225bf369158621b00247"
    sha256 x86_64_linux:   "1e535f44961165f3c6df2aaf5f8867b06511d4820cc100611170d9ac58ec4ac3"
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
index b4f03a72..5ca65cb2 100644
--- a/build-aux/m4/buildsys.m4
+++ b/build-aux/m4/buildsys.m4
@@ -323,7 +323,7 @@ AC_DEFUN([BUILDSYS_FRAMEWORK], [
 			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/Frameworks/$$out/$${out%.framework}'
 		], [
 			FRAMEWORK_LDFLAGS='-dynamiclib -current_version ${LIB_MAJOR}.${LIB_MINOR} -compatibility_version ${LIB_MAJOR}'
-			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/../Frameworks/$$out/$${out%.framework}'
+			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,${prefix}/Library/Frameworks/$$out/$${out%.framework}'
 		])
 
 		AC_SUBST(FRAMEWORK_LDFLAGS)