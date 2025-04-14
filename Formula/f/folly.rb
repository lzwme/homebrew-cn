class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2025.04.07.00.tar.gz"
  sha256 "414e489a9056945ae3afc2e770be52141df3a5b2eb908d0e8150a0ca2d099e0b"
  license "Apache-2.0"
  revision 1
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b936a6442aaea3a14c6c32485b689134c94986d4a97d22225e5e9e78d6e4615"
    sha256 cellar: :any,                 arm64_sonoma:  "e28b0e4e49c52ebf2136ab7fbd6ce43d8fd1d5a54e95b62dee44abd2ddc7d95b"
    sha256 cellar: :any,                 arm64_ventura: "54859a73d4f41fde9f95d891a0ae6a5102443fdd120f68678e6649a3d0423f56"
    sha256 cellar: :any,                 sonoma:        "025b9a7dc9435da765f8b04d1cfbf19186222b76d89db7e800816e5c9f80a98f"
    sha256 cellar: :any,                 ventura:       "a037bdc7ddc85addedeff0ff701212800d443079ab9adec5cd50d4a39b9596de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a8875731a11bcc0fd72c98d56e28d62ba2cea9400653eb7d505908f1b80c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa8bab84548015db933688d8e73ff9805ac2b981924383a3b1d8d59c448b9b7c"
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