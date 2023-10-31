class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.10.30.00.tar.gz"
  sha256 "18ec1ae678187b5fc38a975e10d9fa981d1da5d4b80b16b67b8407d3db11388c"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09c9cf798a18f03979a1d9dd0dde23912e8e2995372a56bf37092fe6abd8e2af"
    sha256 cellar: :any,                 arm64_ventura:  "b05d2148764c6c298bfde18b4e913d66e91387f0b2319e6df5be890e21c0b9e7"
    sha256 cellar: :any,                 arm64_monterey: "c1bb50b2ef2c30925e0fddb0f97f0fca2fc64892887e63e49cfe9c6749f79824"
    sha256 cellar: :any,                 sonoma:         "24547c2c0320821f4791797becfa424094f076eb6cdbe95e7c2f1282e06cda8e"
    sha256 cellar: :any,                 ventura:        "e4748bab7b491aae3eec424bda522f60ad159740cd7f628ee6685866de21a997"
    sha256 cellar: :any,                 monterey:       "2d601fcc306d0dd040fe2d542b315865f52962b55f475b920a43b6cfdb7da4f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d4c2298a9f84933fc6030d38edd824c6e72199395873aa98c7fd8d89a31c495"
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