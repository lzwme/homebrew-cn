class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.03.18.00.tar.gz"
  sha256 "fc10684d7acaaa6bd8e57e129503cb2524b7433bff95aa40d4fed2c59b93fb60"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2242e77aee8e0206d76f8f879ad73521fce906128f986c57780b337e1efcd4db"
    sha256 cellar: :any,                 arm64_ventura:  "52a2a547f10c83b78701ec04a21127817527aa7a4da50fcb12b84d6e1176f347"
    sha256 cellar: :any,                 arm64_monterey: "52aa2113876edac6c5dcce86e25f6a952a8f9a833a418335ecc24b70d0157015"
    sha256 cellar: :any,                 sonoma:         "cca17879f86fe9be2393757c28e959424d8e2bbd91568407c52eccfaa9f09643"
    sha256 cellar: :any,                 ventura:        "daad90c95e5c2f7aff36a3d4930d97d99864761d32d4a1769bc829f8ab28a0a5"
    sha256 cellar: :any,                 monterey:       "79ebd8ddce5127ecf319b18ca95015479ce84a5387a783cc47bcf63031ef82ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f7afee23422aa8109b72de2c2b89174ed73b7c55089332471f1a7108a174e76"
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