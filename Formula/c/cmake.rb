class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.29.1cmake-3.29.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.29.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.29.1.tar.gz"
  sha256 "7fb02e8f57b62b39aa6b4cf71e820148ba1a23724888494735021e32ab0eefcc"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https:cmake.orgdownload"
    regex(href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8d5c71bce53c78741564dce4fec1292039cd5a19d13ffba16c352c9a9f0ef28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df8417a1066147c7a728602b86fbd746b87ddaf1995d2c3c15706c8f7e1ce14e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d385e28294244b9df95178e020fb3e8d2633d95175ec4fafece2c0f63275644d"
    sha256 cellar: :any_skip_relocation, sonoma:         "447617ae169adea3b9092e466cdb383df7e6dac0beef66036a44f0989b37d400"
    sha256 cellar: :any_skip_relocation, ventura:        "8524a278943b3a44b11e70cf82facb11d32f32483627de2dac94cebeb4f00748"
    sha256 cellar: :any_skip_relocation, monterey:       "07166530d9015f13113bbe8da953f011e18df414914d87e7a7299f8b2f0a88de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1723aa66a1ad9cc8c6d711ccc90c6efcf7cd7a09d4ca2f9bc03f96619550b422"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  # Upstream patch to fix regression in LLVM build. Remove in next version.
  # https:gitlab.kitware.comcmakecmake-issues25883
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=sharecmake
      --docdir=sharedoccmake
      --mandir=shareman
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system ".bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath"CMakeLists.txt").write("find_package(Ruby)")
    system bin"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc"html"
    refute_path_exists man
  end
end
__END__
diff --git aSourcecmGlobalGenerator.cxx bSourcecmGlobalGenerator.cxx
index 185bff985fde40fe8e1bd08573b84e76c24f4a1a..1606eec57bb612c5db30fa284777b52ac948e9be 100644
--- aSourcecmGlobalGenerator.cxx
+++ bSourcecmGlobalGenerator.cxx
@@ -28,6 +28,7 @@
 #include "cm_codecvt_Encoding.hxx"
 
 #include "cmAlgorithms.h"
+#include "cmCMakePath.h"
 #include "cmCPackPropertiesGenerator.h"
 #include "cmComputeTargetDepends.h"
 #include "cmCryptoHash.h"
@@ -270,17 +271,14 @@ void cmGlobalGenerator::ResolveLanguageCompiler(const std::string& lang,
 
   std::string changeVars;
   if (cname && !optional) {
-    std::string cnameString;
+    cmCMakePath cachedPath;
     if (!cmSystemTools::FileIsFullPath(*cname)) {
-      cnameString = cmSystemTools::FindProgram(*cname);
+      cachedPath = cmSystemTools::FindProgram(*cname);
     } else {
-      cnameString = *cname;
+      cachedPath = *cname;
     }
-    std::string pathString = path;
-     get rid of potentially multiple slashes:
-    cmSystemTools::ConvertToUnixSlashes(cnameString);
-    cmSystemTools::ConvertToUnixSlashes(pathString);
-    if (cnameString != pathString) {
+    cmCMakePath foundPath = path;
+    if (foundPath.Normal() != cachedPath.Normal()) {
       cmValue cvars = this->GetCMakeInstance()->GetState()->GetGlobalProperty(
         "__CMAKE_DELETE_CACHE_CHANGE_VARS_");
       if (cvars) {