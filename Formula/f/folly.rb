class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.11.13.00.tar.gz"
  sha256 "67fd1dbc5fa6b49a2356911e4d1c317f36fa11b161d1caadf6233b3681018a54"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "34dce7cf349f509d972cd36d156be0a942efe0c7796ce2c47918cdbbcdbf458e"
    sha256 cellar: :any,                 arm64_ventura:  "e8f3b12b96b15cfc8dac66fc19550df5fc5c73e1b71e28a678c09a60b4b4ac16"
    sha256 cellar: :any,                 arm64_monterey: "1dbc57f186bf66dafe2e87638357c34e792c841bd131372935b5f04af70ba3a5"
    sha256 cellar: :any,                 sonoma:         "fee2d02be8ac792b4e3a65dcded181f2ce5ab00ab3e5824c4c9990165d0bd7be"
    sha256 cellar: :any,                 ventura:        "c85eacacc95e6a8688b8c69c6d4f73387b88e9e1456fdf86636fdbf6cce2d50e"
    sha256 cellar: :any,                 monterey:       "2b53c57cf5bd58e70957146431dd18c15756cbbe9585c5f5b7c4612c033edb0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9e7aeaaf8f09f2c6ebf414657c6d8cde29b2fc8c9d7d60369d972be7436b0fe"
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