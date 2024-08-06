class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.07.29.00.tar.gz"
  sha256 "fe1e79890b3b0ddaf8031e534ce85e031b487b8fcb6996a7c4d146dbac54ff5f"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d96fb555bbc71c2200c479848444a4eec3203cb9944ba3b7c06fbcb53873df1"
    sha256 cellar: :any,                 arm64_ventura:  "870fbd8a6d80fc6867a6f48ae304994d67f48538c34a7da3a3fa3481288d2ac8"
    sha256 cellar: :any,                 arm64_monterey: "6b222d5a4bba6c9962df8e7c02ee540c9a9f45b4db0f94d6c8aaa51cad2b035e"
    sha256 cellar: :any,                 sonoma:         "81411321cd07aa30c3e88d92c536d9d94e0e1cb8126877328d98574cd21be853"
    sha256 cellar: :any,                 ventura:        "23d73377b2202ac528110885e77040856634150b923c9e9300253bcbcdb4f160"
    sha256 cellar: :any,                 monterey:       "c86f5500ce5d0e18405a03fcc9479f56eb07efdb11358070b32285767bba47ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "986524cd51d81cdd00b5ebcaaa97ff7a517d7150a988f03b891965d706479cc0"
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