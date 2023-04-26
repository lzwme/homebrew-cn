class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.04.24.00.tar.gz"
  sha256 "3d3c7675d9d2699bd89f6d6fe1d2d4647bcb505f86c8d94b2a99504e01627ff7"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ca02497b3c7c88cfa4d48ac67c8ffddc0090e8a4293618c39552aab2f37c3c19"
    sha256 cellar: :any,                 arm64_monterey: "d56945f42a0d4f5671ed459b38f06b08aa2cd1513a498be6649601436999ebf5"
    sha256 cellar: :any,                 arm64_big_sur:  "dfbd15d3f0b162dacbcb66a435004c396054d694a704373665bc4d0fad87f5eb"
    sha256 cellar: :any,                 ventura:        "71ad365cbec890c27cd0386408cc07ef6285707c6d2ba50e9c0f6d84c9e40247"
    sha256 cellar: :any,                 monterey:       "5e0221cf185d9da5ab347ccc570449ac675e9729f1bfbff7b03238ef93a0199b"
    sha256 cellar: :any,                 big_sur:        "bc7a248374b23c2963f0fab854046766a0e5e16883c0832924a62a7ae5f93ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc90bd7b0324fb0a4b248d6d59877214081164ef65e62b2aa4303b800b8c25b"
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