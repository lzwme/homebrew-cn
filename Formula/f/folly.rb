class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.08.26.00.tar.gz"
  sha256 "7f08016988ca146c77ced2fafd2ae6b39159ab7f99e7eb0c3e8eeed8dc09c03d"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8bdfca6eb4d7d6c09cb0f4dc0366ff2ca22bd0a2260e390c270b6da5c496034e"
    sha256 cellar: :any,                 arm64_ventura:  "fc77c5fadc869e86e418c8733273b39e8c045e01930dfd9a5b9b017155b2501c"
    sha256 cellar: :any,                 arm64_monterey: "607ee322f30742093f1ea75485a0af5fd4dd2ea2aff21342babc36f375edb659"
    sha256 cellar: :any,                 sonoma:         "3c6aabbdeb46ffc0610040bb0a5143abf1eb72534fd1e6f1cb23e14326e41d40"
    sha256 cellar: :any,                 ventura:        "06c66316854ce30a988ae076f0ac7a844f2eccee612a3f1750b9dd3ac4539d6a"
    sha256 cellar: :any,                 monterey:       "c0724009eccf419fb0e521b2216bf9ba4d1fc439013a9c1952e92ceef9f4cee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f4d82de443f07bcadac3681feff0acfc2e17acdb6ae2a9ea9ed687341efc78a"
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