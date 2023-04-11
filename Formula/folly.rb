class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/v2023.04.10.00.tar.gz"
  sha256 "79deee04be669ed45d35534ffd952a7f7ec397519110dc2acafb7e2f230b384a"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f8152b64bf81c4c74af3f6163dbe4e5b24e0090c192cdee39b82c62a7895fcd"
    sha256 cellar: :any,                 arm64_monterey: "7753ab6efe6750d0d0f77a96e13d4a4f339e549feb0b1f9846a977ed6c821e49"
    sha256 cellar: :any,                 arm64_big_sur:  "df512291b05eb2902b84e735a82b72f8b483b508be602df358ace3f9a9f8c150"
    sha256 cellar: :any,                 ventura:        "ed2dce2595cfd594b12186bf447cf734041f38f8be41b50d0eba092f65be523f"
    sha256 cellar: :any,                 monterey:       "3a85b26f3f8abb2957d65c7db4b8c3aa6b4b5c58f51460ebe1fe970b32293d54"
    sha256 cellar: :any,                 big_sur:        "23e92848382a5619281e2ed0036de7e7134babb300fd6e2dae3a9a3a5f15a3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "497260eb024de16cf55d87a84707ff3487688f13620d3fa23b8090a757c87dcd"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@1.1"
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

    args = std_cmake_args + %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args
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