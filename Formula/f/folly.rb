class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.09.02.00.tar.gz"
  sha256 "d95ee2aa8ef2ef4d2a40219ae52c9d0a0e7f3b30e5e1c589ee1795a9ee6564b5"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6e492bdab5902aab91196788042fe6bca1f9729cbac0be805934d9fc33181a20"
    sha256 cellar: :any,                 arm64_ventura:  "b656dbbdcb974d587d566ec2002bf73ea86a5c930dd5f55d21ca880a773e976e"
    sha256 cellar: :any,                 arm64_monterey: "22a577fc875bc72978e16110358aea05463d73cb38197bcd2c33a826995a34f9"
    sha256 cellar: :any,                 sonoma:         "c46e0d548411e2cbf333871eee19bc40757d8b141907dac3c6a9e165a57263ca"
    sha256 cellar: :any,                 ventura:        "75bcb84f53b79ce2ed11901fa1f14fa4b730fd4025fb4c2f2d7f13d9d1abfd9e"
    sha256 cellar: :any,                 monterey:       "40722547ad9f82286a8a6bb98f7de1f8457a9fbf9eaac6a0743991d5b09251bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3cc6fd67c4e3021f57d0675159524f9caa694f903829f2e3b61b8c2e76ce9b5"
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