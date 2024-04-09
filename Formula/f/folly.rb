class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.04.08.00.tar.gz"
  sha256 "fa186c63db9f42157a7ff9ec494b51cf8b8b7f60002020e189b60c6f3fec5247"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b715d5f21e1e557156b3aac1695b0810ee92faeb5453d665346cb0cda338270"
    sha256 cellar: :any,                 arm64_ventura:  "23d8345037cd9d16fa0ba8fbc2d71d810db088ef8d3a6e3f954290683e0f9b95"
    sha256 cellar: :any,                 arm64_monterey: "561456ac3565f0691a4c240be827c39f024f33afbb63a9bc826a1d9585b6f894"
    sha256 cellar: :any,                 sonoma:         "3d9858f7c2cbd2d849a0c8e8ff4af10f0198fdb3dcc7a306f41abaa3ef730eed"
    sha256 cellar: :any,                 ventura:        "6a5191c95272b713591f2e66626dbc89d0880e76b3d4bf7710457d34f58b1194"
    sha256 cellar: :any,                 monterey:       "359253fddc63c99f668a6422a862d3c5c37845721a14e2cddc697095a63d4e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f440223e72ae90faf03ae5fe744a260affbdd01599cdfb232cfdbae292f2ea"
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