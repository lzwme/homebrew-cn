class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2026.06.15.00.tar.gz"
  sha256 "50c9140edea532bc3762c5615eaa5fb908796d4ff7dc99a4d8a1b0aae0ee90e2"
  license "Apache-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2d5cee2b523f1b513592c4e3956aca5b59ece5108225afdb4897eee3b4937bbf"
    sha256 cellar: :any, arm64_sequoia: "2d5539a13b4f20ca6ae4781e7bdd527806edb8f5e696605f13b689d4b982b85e"
    sha256 cellar: :any, arm64_sonoma:  "609aad7f2b33d0e7542df3faf928f6145cd0f0b8d1b0c16fdfb885499e124334"
    sha256 cellar: :any, sonoma:        "f3d8b6c86ec6dd5a37a4035db57929508f174142d642564a14578439ba99a939"
    sha256 cellar: :any, arm64_linux:   "f7031d040e633227b430d1cd77419ccf6d458778e48e5acc6cdce6c1b1edb6db"
    sha256 cellar: :any, x86_64_linux:  "03c5a402b0544ff1e409085256d95a3b0e81e38ec4db0e57e90c8f6e818b5cc8"
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
    url "https://github.com/facebook/folly/commit/4091b8d53a07512d9f8ab2b42d2dd0fddef34e35.patch?full_index=1"
    sha256 "52a2ed7475ba76e54cd902ae035cbc457af565ff0c2cc70453a58fc01b3bc7e9"
  end

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