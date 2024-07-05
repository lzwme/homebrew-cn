class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.07.01.00.tar.gz"
  sha256 "1fc731351f1e22cfa88a39585a80dcd56696a0613fb552b0af6c5d2ac79451bb"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "16298171cf1c8c64ec597fa2d51edfd9077672db24615593eed7be041bee859e"
    sha256 cellar: :any,                 arm64_ventura:  "e6774e6146cbcd9f4515a1e018f3e6512cb49cf5070ab560d60514b0070c6c7c"
    sha256 cellar: :any,                 arm64_monterey: "0a0c8c375322e2adbae293c731bae4982eff802f06b76a4857e20e2288336b06"
    sha256 cellar: :any,                 sonoma:         "e79da56b74e9495a3074510846816164a2670f378776775069923651569c4b30"
    sha256 cellar: :any,                 ventura:        "13ac31644b0f3ccc6bf569e6826a56b198c93917c2eb55dbaeaba4ffc6c224dd"
    sha256 cellar: :any,                 monterey:       "8be2978782d83845d43dd7b08dc9a5c550c6b645fdbf8368aad88b9520c64fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6348986e9eb9ffc9ef51ce0772b3aebfcab98aa037de711c1e2492592daf1df"
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

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https:github.comfacebookfollyissues1545
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

    system "cmake", "-S", ".", "-B", "buildshared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", ".", "-B", "buildstatic",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildstatic"
    lib.install "buildstaticlibfolly.a", "buildstaticfollylibfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath"test.cc").write <<~EOS
      #include <follyFBVector.h>
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
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system ".test"
  end
end