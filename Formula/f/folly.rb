class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2025.10.20.00.tar.gz"
  sha256 "5c609f57f56e06316f38b05361a8244afa2a5b00e39ba170f96052ea33eda30b"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22eb979031f9a85f2653119f2cfe9980330103d9743884799d18c6c1fb592794"
    sha256 cellar: :any,                 arm64_sequoia: "ef3fc986aca354662c360f51e566d3f755dd3ae7191ab3cc3941a1263426a56d"
    sha256 cellar: :any,                 arm64_sonoma:  "44c7dde8106e7243a2ddba1c09ebaa4f8aa1a5f5c4a7b665a21651e1a95215bc"
    sha256 cellar: :any,                 sonoma:        "4c67dc3fff2eb19990df474c79b0c852bf323bcd7e59a4bd9ebb5729299ee84b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27045b9f8709c2576bd0737c98115725496fb6ed3e7273b666d8013a22418783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f1fc97790083f18f816ec461f440878e84a96714e2c7cef341b13986d524ed2"
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