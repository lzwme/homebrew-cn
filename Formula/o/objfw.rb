class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.5.tar.gz"
  sha256 "798bda0590970fea10d5c8064e98088bb9960b3bc0475d92db443b0df9f205c4"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6cd73db79c0e21d95036906819eaaf2863c81be7916e43188f9b74fd37b5d648"
    sha256 arm64_ventura:  "5fef14ca784cd117cf634c9c506a5e447c344c377d1cce3099d63b012736061d"
    sha256 arm64_monterey: "f31240f090292d616a1eb9b3d644d345c93d5dd88b7fca53d4d6a43db9f7190a"
    sha256 sonoma:         "a47b466c0c9ad124af99956fe345c6ea64df91c1d1899999a86686b0c5b1ead3"
    sha256 ventura:        "2cd33e10d36bde0df6e2c8f343928d357801f9ceebaf3ffa65d5a8b574fa4b3b"
    sha256 monterey:       "c5c09555731871883ba8f6dfd1b90c500ba037f905710598b5a67cd598688b52"
    sha256 x86_64_linux:   "a861f62637989992477c09d192c7c2e1b1704522b3abd92b0b9c0f35b65d3f40"
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