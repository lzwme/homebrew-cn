class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.06.08.00.tar.gz"
  sha256 "61c3a415e46e09e01f313e1d135b7b1365251bb7885fe910385ea8a150be2554"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "011937636a618a515cc84b93babf2971922332807db7d3d5604d145d8f73eaca"
    sha256 cellar: :any,                 arm64_monterey: "b27e45fe701c10fd925887f9aed72dc81263c2b17d60318bdbde29a68be9cbad"
    sha256 cellar: :any,                 arm64_big_sur:  "acae6fbcf7e97f2ad857dbcdc1ad9d511290a8df7c04d13ce0618435869cd429"
    sha256 cellar: :any,                 ventura:        "8a8119802bf7058689df7d05dd71751f9ce65b1aa90da17766e209d5d2947a19"
    sha256 cellar: :any,                 monterey:       "3cacbcf36e82360bea712310d91bbb3f5ac98f1fddca314e01f0c7bfadb5c813"
    sha256 cellar: :any,                 big_sur:        "ac29468c47a62a03dbd5c453f9bb250cfe0c263b080ad66fb642a0ac026cf1d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb477327e2a5cf19b94355f83976f1d899f93f36574f79400983d8eec43e88f"
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