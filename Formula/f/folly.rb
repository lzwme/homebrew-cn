class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2025.09.01.00.tar.gz"
  sha256 "33affeb1a5f2575cc1a87fce6b07df1cf63c1e2fff201b3f100cbd98ce602580"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "821a646ddfe95aff3ef48d407f6c9375fc330c4ba6055077b57069dafea19f22"
    sha256 cellar: :any,                 arm64_sonoma:  "66c0fd27f31e201b455d461105260c4f6f026cba23358b2a5d6ba6bf0ad8c60a"
    sha256 cellar: :any,                 arm64_ventura: "393bcc34761f1dabdb929397553a58816dc80da383c28106ed5f262f290895e3"
    sha256 cellar: :any,                 sonoma:        "7654853d2bf01d64e7e54327a8830a3fd7e4c5e137099b3d0382b95332bb5264"
    sha256 cellar: :any,                 ventura:       "d06b3c9dff3b44577d724f83ae1b6bc350d05998e1487d370ad2f7bc5a453856"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d42633d9e63e004fc8b0b7f97e2329ead4c127b73ed4e16a0bbb31c3705e31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1216253a9b0bf32272790d42601084cf2ffd30d4bcbf9264c47fea1b53caa66a"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  # Workaround for Boost 1.89.0 until upstream fix.
  # Issue ref: https://github.com/facebook/folly/issues/2489
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
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
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

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
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/CMake/folly-config.cmake.in b/CMake/folly-config.cmake.in
index 0b96f0a10..800a3d90b 100644
--- a/CMake/folly-config.cmake.in
+++ b/CMake/folly-config.cmake.in
@@ -38,7 +38,6 @@ find_dependency(Boost 1.51.0 MODULE
     filesystem
     program_options
     regex
-    system
     thread
   REQUIRED
 )
diff --git a/CMake/folly-deps.cmake b/CMake/folly-deps.cmake
index 7dafece7d..eaf8c2379 100644
--- a/CMake/folly-deps.cmake
+++ b/CMake/folly-deps.cmake
@@ -41,7 +41,6 @@ find_package(Boost 1.51.0 MODULE
     filesystem
     program_options
     regex
-    system
     thread
   REQUIRED
 )