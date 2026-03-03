class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2026.03.02.00.tar.gz"
  sha256 "f2a9bbd4bd36256d4554f9917fcefa9ec356cec637d2a743e01a6a1d569224dc"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1cb23b2dda767c57c67f9af304c8b024f2e20915899f67a337babe2adcd6c439"
    sha256 cellar: :any,                 arm64_sequoia: "4fa29e77619fb5cc9e7254e153bf33286facdd664055ea6a086f8dba10126d4f"
    sha256 cellar: :any,                 arm64_sonoma:  "c6229c9457a9a12dd26b3ffee0bd6ad11b82a9ce98c0f253684946cbebcf0d76"
    sha256 cellar: :any,                 sonoma:        "1bb078819c030ca11558a371a4a256d75937ad8633fbdf55d831f4df8506794a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8887b0f37d7b75d7e0a92b07f3d23afdc742edd62c5562033e37b068bc43888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd64c8ea8cecfe6f2787fb9885d862efca2827f427a38bc93ee8f00d9eb47fad"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  # Workaround for arm64 Linux error on duplicate symbols
  # Based on https://github.com/facebook/folly/pull/2562
  patch :DATA

  def install
    args = %w[
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}", "-lfolly", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/folly/external/aor/CMakeLists.txt b/folly/external/aor/CMakeLists.txt
index e07e58745..1429f54e9 100644
--- a/folly/external/aor/CMakeLists.txt
+++ b/folly/external/aor/CMakeLists.txt
@@ -20,6 +20,10 @@
 # Linux ELF directives (.size, etc.) that Darwin's assembler doesn't support
 if(IS_AARCH64_ARCH)
 
+if(BUILD_SHARED_LIBS)
+  set(CMAKE_ASM_CREATE_SHARED_LIBRARY ${CMAKE_C_CREATE_SHARED_LIBRARY})
+endif()
+
 folly_add_library(
   NAME memcpy_aarch64
   SRCS
@@ -34,6 +38,7 @@ folly_add_library(
 
 folly_add_library(
   NAME memcpy_aarch64-use
+  EXCLUDE_FROM_MONOLITH
   SRCS
     memcpy-advsimd.S
     memcpy-armv8.S
@@ -58,6 +63,7 @@ folly_add_library(
 
 folly_add_library(
   NAME memset_aarch64-use
+  EXCLUDE_FROM_MONOLITH
   SRCS
     memset-advsimd.S
     memset-mops.S