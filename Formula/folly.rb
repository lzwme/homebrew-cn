class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.07.10.00.tar.gz"
  sha256 "ee4346f6dc9288bbcd8b016294669fe16cac36132c33ef039286962f85229250"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "77fae31da66f86cc7ff5044cdb92988acd5c8319e3824ec9eec788af85aa1a24"
    sha256 cellar: :any,                 arm64_monterey: "16b013365eb4e1bb7e25d144e764bf78c22e82e1b48b49b2b34f82a1e679e517"
    sha256 cellar: :any,                 arm64_big_sur:  "9b9c041eae427c31dbc22275e7dbcacf10ee39b5f9c956e139bdcfde746a5a3b"
    sha256 cellar: :any,                 ventura:        "15e27bd0bfdeec39c69da9e207118f6a3a9a87afa2744a453da08df2f8c1f4ea"
    sha256 cellar: :any,                 monterey:       "51433047af6537d5716dec466fd02ce6ada2d686f6e3e0b675a8d6597f3c092c"
    sha256 cellar: :any,                 big_sur:        "fa9aaa296d6248aa04472aa891ed1d6e74f9032863772da092c35e61cf0eb9eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c501bacbc90f6a2935a40c9f53429b586f2e564dc4a18b3e56572c7185007589"
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
    # https://github.com/facebook/folly/issues/1545
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

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
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
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end