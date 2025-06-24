class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2025.06.23.00.tar.gz"
  sha256 "fa4cbe9accbb4fc84b40f610a7a3c1617a2ddc55a11acf9353c8edf5fd0e5547"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9351b97f66fd657d40049e776529be90e52e7c0d5ed8a59ac0a7c82f3eb3c53c"
    sha256 cellar: :any,                 arm64_sonoma:  "c610c1b2df2033cbee75718530acbcb29caa2e1a6ec504801617e22297b45f8b"
    sha256 cellar: :any,                 arm64_ventura: "496f3168af5efcd5cf390496e7c312bfafa9bf0728c11df64c35236bdbb5fbe1"
    sha256 cellar: :any,                 sonoma:        "ed46289e366557705dc48a68d92139b17ba16f4361e5de0b77272c4d3c9bb4f9"
    sha256 cellar: :any,                 ventura:       "572ab0ccad223bef4d2612940da036cef709db0b30b7dc22d0277082cef2fbda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f43d19988e7b34dad1393c940097ef7a1890c3c6bc82702e1f9a1791e4b01a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67aabf0f7e5ccf760a62749e31cc99d8228c328d900d50eb324be3e8e74a05eb"
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
    # https:github.comfacebookfollyissues1545
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

    (testpath"test.cc").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system ".test"
  end
end