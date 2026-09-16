class Snappy < Formula
  desc "Compression/decompression library aiming for high speed"
  homepage "https://google.github.io/snappy/"
  url "https://ghfast.top/https://github.com/google/snappy/archive/refs/tags/1.3.0.tar.gz"
  sha256 "695d585b7679489a5dc9f5148a91781c8a14f4a9a5dbcdb5672ce0e761468b23"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/google/snappy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "56a72b07396e784b1baf26bd6d3e17eb4f42d6daaa547d94c2c0c7af46d3ab3c"
    sha256 cellar: :any, arm64_tahoe:       "ed46206fcb9d94e26c725e32e2628d1b5316afd6b59bc2b5352ca05c462103da"
    sha256 cellar: :any, arm64_sequoia:     "b494e64dbd96af17defdb6a0ebf60edd284d3df904c867c825c2d5cf9033782b"
    sha256 cellar: :any, arm64_linux:       "7a621f5fa89c4339bee3cc592331f6d5c1adabc7ff1e7349670cc1039b3c85bb"
    sha256 cellar: :any, x86_64_linux:      "18aec5843943b24eb10d51af1d42b6a7e32120b46a045bbf0bc5e908fbb5f837"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  # Fix issue where `snappy` setting -fno-rtti causes build issues on `folly`
  # `folly` issue ref: https://github.com/facebook/folly/issues/1583
  patch :DATA

  def install
    args = %w[
      -DSNAPPY_BUILD_TESTS=OFF
      -DSNAPPY_BUILD_BENCHMARKS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/static", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <assert.h>
      #include <snappy.h>
      #include <string>
      using namespace std;
      using namespace snappy;

      int main()
      {
        string source = "Hello World!";
        string compressed, decompressed;
        Compress(source.data(), source.size(), &compressed);
        Uncompress(compressed.data(), compressed.size(), &decompressed);
        assert(source == decompressed);
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lsnappy", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 1cab614..bd065a9 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -57,10 +57,6 @@ if(MSVC)
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHs-c-")
   add_definitions(-D_HAS_EXCEPTIONS=0)

-  # Disable RTTI.
-  string(REGEX REPLACE "/GR" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
-  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /GR-")
-
   # Support static MSVC runtime when building static library.
   option(SNAPPY_MSVC_STATIC_RUNTIME "Link to static MSVC runtime (/MT or /MTd)" OFF)
   if(SNAPPY_MSVC_STATIC_RUNTIME)
@@ -101,10 +97,6 @@ else(MSVC)
   # Disable C++ exceptions.
   string(REGEX REPLACE "-fexceptions" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions")
-
-  # Disable RTTI.
-  string(REGEX REPLACE "-frtti" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
-  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
 endif(MSVC)

 # BUILD_SHARED_LIBS is a standard CMake variable, but we declare it here to make