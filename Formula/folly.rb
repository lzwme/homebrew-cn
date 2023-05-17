class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "6654d7f4ef5356cf2af6fc8b0f98dcac49a09a53f66557b01203b6eaf252864b"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1ab17af5ddae509e4047c4051b2516d32a310952e34f9bdfce1af0b420a3f6b4"
    sha256 cellar: :any,                 arm64_monterey: "e67e43261c268983eac3fc0c2d910aa1698629465ea7138c4c66082419b931e1"
    sha256 cellar: :any,                 arm64_big_sur:  "e51aefc6faba8762189a826f2ccce594107bf76049caadccc153ba6d63429eac"
    sha256 cellar: :any,                 ventura:        "cca91c95aedf294f268f8097c0f35b075a791416dc8bf6c8b8087cf6a4a6614b"
    sha256 cellar: :any,                 monterey:       "d7448b8c34d4c9791967deee607cfce2d603be49e96b7f8c026ab5d3452bac6c"
    sha256 cellar: :any,                 big_sur:        "7fbec007026296fe385f698dfaf63ba920624169f3507be13a19d80d67bfff51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91d0640b900be2cadb6f5774b7bd84c9f4db72c4fe7ee18573a4651cbbf5e34a"
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