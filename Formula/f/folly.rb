class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.09.16.00.tar.gz"
  sha256 "6c6ecace1b7d44686118900db171d800e5d34fc7f1bf1c835d1009f159be159d"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b9eced736ba79c2a20fa0618d8321ee932d5563ec33aee03729fb922f4e6d2e"
    sha256 cellar: :any,                 arm64_sonoma:  "460a52e2af24c9db25335fc2bfcd3c8c88fb6003eeae051581f34a5f6d1114ee"
    sha256 cellar: :any,                 arm64_ventura: "9a9e370f17bd45f4c5e98992dd9455954ace1ba6f6902d2f125f8c56fa33e92a"
    sha256 cellar: :any,                 sonoma:        "fac4637ca4798c10c35f5379ccef5a7b2034ffcdb34b30fc2fe8ee37964eb942"
    sha256 cellar: :any,                 ventura:       "e5887241f66ead67a488e4f457bd3aa343e6de1dd1f7055e68e6e94d88cec49e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cdc40d41c412b8abbbfca3486657238ae29cde72e7057a253ff34e63cb7ea68"
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