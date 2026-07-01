class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2026.06.29.00.tar.gz"
  sha256 "75520ee4a0e6aae4aa0c59ff61c908398ded8394ede95d038d20ce5994947567"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "419848acd6b7406ad3566b5c4af061dea1e5c239ef5073190c3eeb7d9a9eba08"
    sha256 cellar: :any, arm64_sequoia: "4df2d8d7937f4ae1e40f4809ffc4b46d1ad1f25bbc186062f973394a2eb76e16"
    sha256 cellar: :any, arm64_sonoma:  "e5ea242fcbfc95a9b3d47d38af47e2bbe65404cc7f01742315dd21f757cddee5"
    sha256 cellar: :any, sonoma:        "d71e99616af3639f95ec5863485745922848ad5ac72221818c19629a3711595a"
    sha256 cellar: :any, arm64_linux:   "5e5b74699130d9eb81eb197d50dea8a5f5986cf840b2497c1f8f33800c1e1e4d"
    sha256 cellar: :any, x86_64_linux:  "94bc3ae0e42d94870bca83dbb22c5b63bd77f6a4a4a366dbbc035ea9267b5dd1"
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