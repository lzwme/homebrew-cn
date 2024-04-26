class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.04.22.00.tar.gz"
  sha256 "872952ed18df1d063a439bea80500dd1268eb9fcb344082ced02c2cc4545f0ba"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a0a6b5c9371d4275baf7583ab1cc3982c975e4367f0bae0d8af691c61e8f26b2"
    sha256 cellar: :any,                 arm64_ventura:  "9f0f49d1cc41d87ade8e8329e77422eda9f49d425e5744fc9965ec30d7f45e3d"
    sha256 cellar: :any,                 arm64_monterey: "6d48c1dbd6c65f6de67f67553ae79345f6cd9b700d6e41e6c0a89147b76a9055"
    sha256 cellar: :any,                 sonoma:         "f8ac17b48606837786599bb589f1c59355bbae44a97579a37af56f7342670709"
    sha256 cellar: :any,                 ventura:        "8826de64c5cc9d8609b611bebf54403f9e1a846d874172c70d10e1760d715b74"
    sha256 cellar: :any,                 monterey:       "835df6de5dcf27285318314a03e2bf840262676cc4d492a85783cc1252d4d6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67568f065fef5df1dcefb05e759ee35346af6bccdc3a0d723c36ff3e82e8a57b"
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