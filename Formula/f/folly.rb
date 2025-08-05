class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2025.08.04.00.tar.gz"
  sha256 "7bc57f84a8bf4cb7f7746b9bc8eab799ee03bf8ade868e145547b0b7a6796484"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f5e27e7d854aa4b3f19268f939f830ce995be74e1accc8c06b7b68eb44778bfc"
    sha256 cellar: :any,                 arm64_sonoma:  "95ff97dfd96c296998bd517afd97c0843f7b403beaf6aa58723a8a6b036f1a85"
    sha256 cellar: :any,                 arm64_ventura: "65ac6182581e92937e07a9811249a7db436cf63e817ee3ec3edd8e9a320882e1"
    sha256 cellar: :any,                 sonoma:        "d4876d495229e09f67f9debe750f2b45947b99e5b5d0d9bd50755a4aa9164fc1"
    sha256 cellar: :any,                 ventura:       "a3904d2a8f1a56f3d48fcedc04443272709061394616198526ba61fc3f2b1449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "300024bab4ad1b7738fa4ad071b9356cc6184de84cf7a36f4251249de3c94e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72f5bc1481025fbaca2dfb74bf1044ff63a45eb66fdbccc1d5ffa76b4a4af516"
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