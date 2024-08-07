class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.08.05.00.tar.gz"
  sha256 "02a9d566a60156d51bfbee7a44e4f352737459547d9008b0b13a8c029e36f5a4"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3c7d34ad72f4fc7a28d649b6ff74625febdcce68156c2b6c5fd760f33827c74"
    sha256 cellar: :any,                 arm64_ventura:  "db023d8b8ea486e37e90a4de864ce8acdbf232cba941035e5d3f4fdfec27319d"
    sha256 cellar: :any,                 arm64_monterey: "84f8ecfc72b501531dc2b1db78172d71d3211ce7d8048e6f9a4bda7df707f5ca"
    sha256 cellar: :any,                 sonoma:         "34a62b55a3718e7d8ee18247078d6f99f41644932136dc07717261a75af87175"
    sha256 cellar: :any,                 ventura:        "175a9439928167e2417391c437c3ccaee7a9e0d9ed1b9a98be0c400c1863ccd9"
    sha256 cellar: :any,                 monterey:       "88d77b17177a42590dbb07703a981fec2eff88db6354a14701ad7e1df02fda55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5fc61c0d0820e4d1ee5b6e92e60a532248536abbc3a7e88f0b227226585a872"
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