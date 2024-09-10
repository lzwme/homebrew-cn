class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.09.09.00.tar.gz"
  sha256 "3005e3247b40e5b50b8b28936a3c1baeac9aec411e5e20057eb49d1298883cd7"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "10690f3d2075650447c7825d54b4b42f67ee6e1990f3ffbd13bf3b1946cc1d2c"
    sha256 cellar: :any,                 arm64_ventura:  "f9040fd7f5e9bef4732f8998d2c0a27e7145b13fef2ae64b2eee6e74d52da052"
    sha256 cellar: :any,                 arm64_monterey: "81e7dab70c8046a031954f16d41c9aeceb5a14d91a768d325a4c75825d739a2c"
    sha256 cellar: :any,                 sonoma:         "6558ed8dc43d04e88748d41f37b672bc2744ec40e1b8ca023e49f48d0c2bba74"
    sha256 cellar: :any,                 ventura:        "8466ecdae544bc847f42845e323045638a0ccc2d2d65ec17130b8ecbe8e2a44b"
    sha256 cellar: :any,                 monterey:       "5bb8b4200cb23c702a4d5604b710e7f611522613fe43852c3336bced400fbca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fae15dd0176d6366a63b3f6a1701926bd20ff2c49ba6b3a4ad567f15edb87cfd"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
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