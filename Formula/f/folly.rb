class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2025.05.19.00.tar.gz"
  sha256 "c60daf2e709e0a3fd428d09a1e3439c1836189d4248189a1a45f33500de90eac"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c46a6fd27f4021c9c21405dda75eb3f21c8ab1d9a5ef94f16637a3740b59b724"
    sha256 cellar: :any,                 arm64_sonoma:  "71ef38237aa9d8cb786df7a1c98c08888d4a08032895471b9e4123f8ed4e088e"
    sha256 cellar: :any,                 arm64_ventura: "0ac7ca7042be24f0921a43cb9abedc79985f3d1723a0faa7fc01e89e9ef9c2f1"
    sha256 cellar: :any,                 sonoma:        "6191d62eb024ad38c40e50cfb47b30be740512081a9c5df8ae32279085a3c14a"
    sha256 cellar: :any,                 ventura:       "3f6b5af50db196e4795bb80bf0f54dd928a2f3406626044fd94c918a0844a9e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f562d7b863f2952a647a94d27c7dae0d07c4d44d748bf48343d8a5683119fdd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a10fece8b794c4165bc9a7b2c3e8040964a4ba05ec89aea0d518597981224a64"
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