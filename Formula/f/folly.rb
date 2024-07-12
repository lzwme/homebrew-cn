class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.07.08.00.tar.gz"
  sha256 "569c913d0fa4892bb7624ee36564fa44fc8f7c9f67b7085da9493f4ad9ca8b11"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6f07753e687461b47501dd25d36e36328cfb7159be2c3596c1c7a873907f0b3"
    sha256 cellar: :any,                 arm64_ventura:  "cce1607c340557786713d84eae61e62dbd6249a4a15f3ada37068f38bc1f1dd1"
    sha256 cellar: :any,                 arm64_monterey: "baafdc867199af5471496b68d6858e27f270dcef6b7f05977cdfe69e8271532a"
    sha256 cellar: :any,                 sonoma:         "4dac25d1c9dc8dff59ca11be1c9127067305d5909aad76f93d8e006d4434095e"
    sha256 cellar: :any,                 ventura:        "e4941452a522611db7b40b87dba0abd476bbd974a8a535bfd485cabd955ebd01"
    sha256 cellar: :any,                 monterey:       "d67baaa6ab9b99ca93e398c5c74a79897db7c6a97762edc0c03040819cf3596d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91a777ced931e67340639dfe2722f89955b9bdb6183ed8aa0d64cfd014292b5a"
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