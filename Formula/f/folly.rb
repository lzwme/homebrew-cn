class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.04.01.00.tar.gz"
  sha256 "8d51e4e5d04ca29b752ecd57831fb78d79036877bbad424b371490b2a8bb5d11"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "721f900eec747db18a98d549bbcf39db1f0dbcd424dc6037c8902636413e7211"
    sha256 cellar: :any,                 arm64_ventura:  "cfe5a51037cbad0382b36596ab326bd8e387d6d0dbfa1c373054a3386f8fb54f"
    sha256 cellar: :any,                 arm64_monterey: "04dd90593dccf897ae17afeab0cf90640c5d62836c6335143179c76cd83cac18"
    sha256 cellar: :any,                 sonoma:         "8102f6625802fb1675c936f9e6540c12cf5d2f8cfcad7a190a5a67ce354748ec"
    sha256 cellar: :any,                 ventura:        "737dc329075bf0d09453ee8f7fb803f1f3a7b4182fc0ec1cec6b9ec4b312b0dc"
    sha256 cellar: :any,                 monterey:       "35f4d09a8028400dd5502f295499942e187463bb92719c1a025483defa87e979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c1092d98ab1e2e99804f965bdfd98e5f0f9230624890db56363983bf1a07ace"
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