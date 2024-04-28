class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.04.22.00.tar.gz"
  sha256 "872952ed18df1d063a439bea80500dd1268eb9fcb344082ced02c2cc4545f0ba"
  license "Apache-2.0"
  revision 1
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9ea7060eee0ffa0f6f819fb68c29eb6576c0dc79702cfe9acfc518c70476aadb"
    sha256 cellar: :any,                 arm64_ventura:  "19291c4178fab1ca2c856ab7579367c820f51ce7fdc84a590830eed64bd02f46"
    sha256 cellar: :any,                 arm64_monterey: "9e26f1813abbcba82a8963cf2ca96b5666e7209bb6d146668ddecc7ec96cb522"
    sha256 cellar: :any,                 sonoma:         "af39ddc8e0ad3954b77dfb7f7647841bf2fc024131e5e7918a2ee39b0dd3e071"
    sha256 cellar: :any,                 ventura:        "3f25205cf84159f3f22d39de4820c889f1b39f80035351249d12be86e76b91ae"
    sha256 cellar: :any,                 monterey:       "7fe7c4d06a3ffc1e0dbf2c4ce4c128e6c1d33632744f7c5d607ae7a94551e8c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a252622d3d6f904b601d39cdd68ebec284fe550bd98bbff474aff0865aa2a5cc"
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