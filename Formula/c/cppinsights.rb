class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https:cppinsights.io"
  url "https:github.comandreasfertigcppinsightsarchiverefstagsv_17.0.tar.gz"
  sha256 "2dd6bcfcdba65c0ed2e1f04ef79d57285186871ad8bd481d63269f3115276216"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "afe0e099c28067cf56276d9165c0c74d5bd60bc1198e35e48cd77a1583e37622"
    sha256 cellar: :any,                 arm64_sonoma:  "ee190f27380bb741eb5b8227bab92af141d582de278914da3d339936cb47e7a2"
    sha256 cellar: :any,                 arm64_ventura: "4410e7e48ebab10cabdb2090f2da11bbfe873e77807c7f3c9c85205d476633b4"
    sha256 cellar: :any,                 sonoma:        "f4790d0acad044e7c039f5d148871c9746c7b79d87a6f66c9594628a04aade18"
    sha256 cellar: :any,                 ventura:       "af24d6cdefa935d7cca9fbc28ae6133b4a1341a6bc3930d3e91b77c131bdd02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d84b7f52fa94bf59a784cce74e72456b6e94436775f9895ecc96cade7b3866f2"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with :clang do
    build 1500
    cause "Requires Clang > 15.0"
  end

  # Patch from https:github.comandreasfertigcppinsightspull622
  # Support for LLVM 18, remove in next version
  patch :DATA

  # Support for LLVM 19, remove in next version
  patch do
    url "https:github.comandreasfertigcppinsightscommita84a979abdd0cd57790d0795c3642198188215e9.patch?full_index=1"
    sha256 "fcfccbddc4e1c4b0fbb359fcd1c9dca58c4a5f15a175c53c449586b17217e079"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build",
                    "-DINSIGHTS_LLVM_CONFIG=#{Formula["llvm"].opt_bin}llvm-config",
                    "-DINSIGHTS_USE_SYSTEM_INCLUDES=Off",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      int main() {
        int arr[5]{2,3,4};
      }
    CPP
    assert_match "{2, 3, 4, 0, 0}", shell_output("#{bin}insights .test.cpp")
  end
end

__END__
diff --git aCMakeLists.txt bCMakeLists.txt
index 31341709..8b7430db 100644
--- aCMakeLists.txt
+++ bCMakeLists.txt
@@ -1,5 +1,4 @@
-cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
-# 3.8* is required because of C++17 support
+cmake_minimum_required(VERSION 3.20 FATAL_ERROR)
 
 # For better control enable MSVC_RUNTIME_LIBRARY target property
 # see https:cmake.orgcmakehelplatestpolicyCMP0091.html
@@ -33,7 +32,7 @@ option(INSIGHTS_STATIC              "Use static linking"         Off)
 
 set(INSIGHTS_LLVM_CONFIG "llvm-config" CACHE STRING "LLVM config executable to use")
 
-set(INSIGHTS_MIN_LLVM_MAJOR_VERSION 17)
+set(INSIGHTS_MIN_LLVM_MAJOR_VERSION 18)
 set(INSIGHTS_MIN_LLVM_VERSION ${INSIGHTS_MIN_LLVM_MAJOR_VERSION}.0)
 
 if(NOT DEFINED LLVM_VERSION_MAJOR)  # used when build inside the clang toolextra folder
@@ -372,6 +371,17 @@ if (BUILD_INSIGHTS_OUTSIDE_LLVM)
     # additional libs required when building insights outside llvm
     set(ADDITIONAL_LIBS
         ${LLVM_LDFLAGS}
+    )
+
+    if(${LLVM_PACKAGE_VERSION_PLAIN} VERSION_GREATER_EQUAL "18.0.0")
+        set(ADDITIONAL_LIBS
+            ${ADDITIONAL_LIBS}
+            clangAPINotes
+        )
+    endif()
+
+    set(ADDITIONAL_LIBS
+        ${ADDITIONAL_LIBS}
         clangFrontend
         clangDriver
         clangSerialization
@@ -768,6 +778,7 @@ message(STATUS "[ Build summary ]")
 message(STATUS "CMAKE_GENERATOR       : ${CMAKE_GENERATOR}")
 message(STATUS "CMAKE_EXE_LINKER_FLAGS: ${CMAKE_EXE_LINKER_FLAGS}")
 message(STATUS "CMAKE_LINKER          : ${CMAKE_LINKER}")
+message(STATUS "CMAKE_OSX_ARCHITECTURES : ${CMAKE_OSX_ARCHITECTURES}")
 message(STATUS "Compiler ID           : ${CMAKE_CXX_COMPILER_ID}")
 message(STATUS "Compiler version      : ${CMAKE_CXX_COMPILER_VERSION}")
 message(STATUS "Compiler path         : ${CMAKE_CXX_COMPILER}")