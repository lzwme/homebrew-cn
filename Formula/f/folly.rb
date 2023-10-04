class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.10.02.00.tar.gz"
  sha256 "8b7dd6857b9cc42a43e346776dbea32e16b953026b213d47ad5f14e6ef04bb08"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a7bb633684864bc5e75be705496ee87102266e5f45d549f0b1794cea5a5262b3"
    sha256 cellar: :any,                 arm64_ventura:  "c2da6040c0c43fb1ec852ff59389b0687ef235b75143453b97e6568234e430d0"
    sha256 cellar: :any,                 arm64_monterey: "a752418a3c4a73ba4c84ec45f83a96f2187e35d8dfb2ee913a6bee0ff453deca"
    sha256 cellar: :any,                 sonoma:         "08937aa2b52e08bc81b6aaf7f6b33213eced3c4c627b087fb46fda25d5df5158"
    sha256 cellar: :any,                 ventura:        "db3a13428848567404590e8388c1eed4e0710137556b4f8ae3b7eb01f99bd309"
    sha256 cellar: :any,                 monterey:       "60188a1e8dba9126d68affa79c3472610ebda32fd31aa3ba6af02917ca6c0a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c36f572160ef67e054f273d62fcd680f78d740701185a0d244e6df933e45040"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  fails_with gcc: "5"

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

    (testpath/"test.cc").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end