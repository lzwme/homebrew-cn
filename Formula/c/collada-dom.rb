class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https:www.khronos.orgcolladawikiPortal:COLLADA_DOM"
  url "https:github.comrdiankovcollada-domarchiverefstagsv2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  license "MIT"
  revision 11
  head "https:github.comrdiankovcollada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f2f14ada8f52d59fab95a8daa171a5f8190c082e3e593200715c15e24128758"
    sha256 cellar: :any,                 arm64_sonoma:  "5751a4df5552a182392748da057b6609ebaf823a9d0f5153e320769ec0c63261"
    sha256 cellar: :any,                 arm64_ventura: "c1c63c11e7a9cdfe018e8840078db2d38118e68484e8aa97c20327d3d313d5f6"
    sha256 cellar: :any,                 sonoma:        "183a9d8e0ec094106681fc44295ed04c3b3575407e6fea95cfae3d257704745b"
    sha256 cellar: :any,                 ventura:       "295fff9dae9857f830805e1edfec4f35a10d80f821c86012549b0d763b2ea02a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9185b9bec36d7fe0a31c70ff2721635135ed089b6b0619d6ed5df45b3541cc90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0954666d6fe07b3cc599f72f797c61f9ef3ae2ba51d3c07dfd876bf3fbe26d8a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "minizip"
  depends_on "uriparser"

  uses_from_macos "libxml2"

  # Fix build failure with `boost` 1.85.0.
  # Issue ref: https:github.comrdiankovcollada-domissues42
  patch :DATA

  def install
    # Remove bundled libraries to avoid fallback
    rm_r(buildpath"domexternal-libs")

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=11",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      #include <dae.h>
      #include <daedaeDom.h>

      using namespace std;

      int main()
      {
        cout << GetCOLLADA_VERSION() << endl;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}collada-dom2.5",
                    "-L#{lib}", "-lcollada-dom2.5-dp", "-o", "test"

    # This is the DAE file version, not the package version
    assert_equal "1.5.0", shell_output(".test").chomp
  end
end

__END__
diff --git adomincludedae.h bdomincludedae.h
index e53388b..a14276a 100644
--- adomincludedae.h
+++ bdomincludedae.h
@@ -25,7 +25,7 @@
 #pragma warning(disable: 4180 4245)
 #endif
 #ifndef NO_BOOST
-#include <boostfilesystemconvenience.hpp>
+#include <boostfilesystemoperations.hpp>
 #endif
 #ifdef _MSC_VER
 #pragma warning(pop)
diff --git adomsrcdaedaeUtils.cpp bdomsrcdaedaeUtils.cpp
index de30ca0..011a852 100644
--- adomsrcdaedaeUtils.cpp
+++ bdomsrcdaedaeUtils.cpp
@@ -18,7 +18,7 @@
 #endif

 #ifndef NO_BOOST
-#include <boostfilesystemconvenience.hpp>        THIS WAS NOT COMMENTED.
+#include <boostfilesystemoperations.hpp>        THIS WAS NOT COMMENTED.
 #endif

 #include <cstdio>  for tmpnam
diff --git adomsrcdaedaeZAEUncompressHandler.cpp bdomsrcdaedaeZAEUncompressHandler.cpp
index da2a344..2550000 100644
--- adomsrcdaedaeZAEUncompressHandler.cpp
+++ bdomsrcdaedaeZAEUncompressHandler.cpp
@@ -271,7 +271,7 @@ bool daeZAEUncompressHandler::checkAndExtractInternalArchive( const std::string&
     bool error = false;

     boost::filesystem::path archivePath(filePath);
-    std::string dir = archivePath.branch_path().string();
+    std::string dir = archivePath.parent_path().string();

     const std::string& randomSegment = cdom::getRandomFileName();
     std::string tmpDir = dir + cdom::getFileSeparator() + randomSegment + cdom::getFileSeparator();