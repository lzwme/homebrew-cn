class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.04.15.00.tar.gz"
  sha256 "3d59eb2acdeec40d662cd48fc37c5f3888f1dbc784064365dda223d67958ee26"
  license "Apache-2.0"
  revision 1
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03e4a02fc7b90fa6e1755c573dd9695c0a7bdfa4cd7aa171882766816a5dc0b7"
    sha256 cellar: :any,                 arm64_ventura:  "62c97971048386111f5e903ea4e757a8fa60440158c46e773422584dd8d00fe1"
    sha256 cellar: :any,                 arm64_monterey: "1d00cce03b997f98441c5bf95e9ff0d4a472d16d5cf186ae3c9cc38278adfc07"
    sha256 cellar: :any,                 sonoma:         "6598034c3e48211f7ea7fd46a2368099cef5f0d08a2be5843191c71c7f79c8b1"
    sha256 cellar: :any,                 ventura:        "74737b0f0c6e284b46ab4c0bc18b3d0183c974f89c61bc72cfaa717f7c6c13ae"
    sha256 cellar: :any,                 monterey:       "1a0fb78aa39b7bae0fca1b2777d00607d68c351ff642b1fa9e6bcebd148805b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec03d0583e6ac173d38b80649c87d2ed65b7ff7eaeaf37b77a08eb80333f29b9"
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