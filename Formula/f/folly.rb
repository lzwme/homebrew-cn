class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2026.07.13.00.tar.gz"
  sha256 "4400e68827b28abfce920882706fa358903ab253fcc547426c39eb425a28e447"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2fe3ef344914179bf633307a2a03b6c456e9148221f2e00c006924cae7917045"
    sha256 cellar: :any, arm64_sequoia: "4e6eea7ad7910873e67162fa0aad5e4e80e163b1fea4ba56efbde5e585c755a1"
    sha256 cellar: :any, arm64_sonoma:  "4f6a1a56cdf07b281621f8b6f06775a0deedd76b485e85e2a42d227b1c140adc"
    sha256 cellar: :any, sonoma:        "c74a2cc8139198804c6e35df01ed4d2f69142d69bdc1b45295d31d65b272013a"
    sha256 cellar: :any, arm64_linux:   "abecb4a081cf8e6fa7d2eed146548618a28523a3677c6e2d959037852ba46e2a"
    sha256 cellar: :any, x86_64_linux:  "16419a3c13fb6c0c37fdafce5a754bc025bc7317ad4924441fdd7de725126358"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix fmt 12.2 compat: https://github.com/facebook/folly/pull/2661
  patch do
    url "https://github.com/facebook/folly/commit/dd2a73e8a3b7a9e044918507d52a780cb181f63d.patch?full_index=1"
    sha256 "3b6138a50d31d785817058df5009343b35d52a8386d494e8e5f62202efcc419e"
  end

  # Workaround for arm64 Linux error "Missing variable is: CMAKE_ASM_CREATE_SHARED_LIBRARY"
  # Ref: https://github.com/facebook/folly/pull/2562#issuecomment-3988207056
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
    system ENV.cxx, "-std=c++20", "test.cc", "-I#{include}", "-L#{lib}", "-lfolly", "-o", "test"
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