class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.09.25.00.tar.gz"
  sha256 "25fbb2d3a502b4e5f64d5c93fd8cb3e927928838ed12011c90e2d462456198cf"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ac55a884385d5322413713d0f03cf0181638d5f4a1410db40868299e444f8005"
    sha256 cellar: :any,                 arm64_ventura:  "50ed60b86080ab29a5a01a08e35a6c47a04d84c367e24fb9a97afef447864e45"
    sha256 cellar: :any,                 arm64_monterey: "e9772050b4c73361479d41ea035a817365c430a75d280413d0d0246c5a8f5739"
    sha256 cellar: :any,                 sonoma:         "b6a5c05964540bb190e64b3b815b8bfb96b894e44a3499733d206f4022cdd0ea"
    sha256 cellar: :any,                 ventura:        "e73f501e091eba2bd5762cd2a75f80c8df5f090304cbae6723744e0a2bb27b58"
    sha256 cellar: :any,                 monterey:       "1c4da3bd584af9c9a5026bd8010d19e176dae59a39fa00f91829f3ba12659ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a61d6e6bee6c0c2db745c2a4ae294e326876de3bcc297bffa9024e7424d57d0"
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