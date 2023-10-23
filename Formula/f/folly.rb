class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.10.09.00.tar.gz"
  sha256 "682b54ba10e36bc4c9bee0a08fd71981584c73e066eb5e573669404cdce0ce66"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "65737124cbc50da6a74dae11a13db32f44ff2cedc1397e75141e5323480b5138"
    sha256 cellar: :any,                 arm64_ventura:  "8494b91f6bb338cc2303ad35a26b85ee74c10a093db8764697820568af4931d7"
    sha256 cellar: :any,                 arm64_monterey: "b6d218c63c06db75f52aa35804944e69a92d199fe0f21a41b423dfaa670519f7"
    sha256 cellar: :any,                 sonoma:         "d39a2ead190a36a994712ea4aedfd97118b52b114f1308fbe67c5701ec7164d6"
    sha256 cellar: :any,                 ventura:        "5fa1b5bfe80decdacb86f55f07cb2e7e38d896291235904730ec014e8f5b2ba6"
    sha256 cellar: :any,                 monterey:       "b3d7c7abb8b29ae8ace29ca8c50aa0c530c5d8c75c7e3be645aa7facd7de9a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd45946364487da7814cf427743e8adb8f44497d62634e63ca28ed2a343d2d3f"
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