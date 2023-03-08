class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/v2023.03.06.00.tar.gz"
  sha256 "04cee9d8a651a4718f359957aceb345bf546c9ac666c249d609e6611f505f78c"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f45d453a4c4683844efef19ef67364aab0c3360d0cab5311d253a2d7b651c7e7"
    sha256 cellar: :any,                 arm64_monterey: "26aa62c699de4ef50c09fb13a091853bea32d1bf028bf5050668e730b2df043b"
    sha256 cellar: :any,                 arm64_big_sur:  "532a9ab6000029a3ecdf7112615b99cf5ea63914a4f3835504c0f34257c389e4"
    sha256 cellar: :any,                 ventura:        "1d3173084aa8a8889b63fab8a854fe53ef11192d3a2c1acb866b5203ab26419a"
    sha256 cellar: :any,                 monterey:       "2f9e8995057db03e173294ea927e95c4f5447ee836a0eb47c1ecd88694cb6b30"
    sha256 cellar: :any,                 big_sur:        "6dc41a236b7c54269ebb2dfc146e69db8f72b860654fbec028070936f7528118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e5cc051fc2413171f6c55993c11973db9cb6f0ee07a1f6c39ef84a239afee76"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@1.1"
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

    args = std_cmake_args + %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args
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