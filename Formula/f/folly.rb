class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.11.27.00.tar.gz"
  sha256 "49c850dbc9600309b0cc595e093c2ebbaa66e664a9b370d542485146aa0cbdcd"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "728e6bba823376cc1c1a87af0f9aadf7f02422633104e695a0d7583b93b6195b"
    sha256 cellar: :any,                 arm64_ventura:  "9568fbaea8c23ed4785ae152b8a1d5e08a7537e86c313c15689ae778becbdd6a"
    sha256 cellar: :any,                 arm64_monterey: "92cf16c0f538c5190fe858b5291758f3032f5c6f91885b2a2a1153b1ed052229"
    sha256 cellar: :any,                 sonoma:         "9568a2422d851200cb79733553fb54ade03bce233e1899ec08e762920ff96150"
    sha256 cellar: :any,                 ventura:        "95f3538835940621d19191a99c79cbb8ca0330aecaad9729aa7e04ef866c9d3e"
    sha256 cellar: :any,                 monterey:       "74cd7722f4fd5acade1b1ddb1bf16d5e98c4c094ffa4fe4bd24dcc9311fe6d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dc9025d00fc84abd7b7553e25bbfff1bcfe27270d039d6819dd8888dd29bc3b"
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