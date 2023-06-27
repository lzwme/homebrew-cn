class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.06.12.00.tar.gz"
  sha256 "cb7d075f5610dcc50084d727ee675daad51733b049f0b07cc112b160e468599d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0e6c4bb3f37845bbce18c03a23455c97a43e61fd5df8f7c484662cfc45ca6ba4"
    sha256 cellar: :any,                 arm64_monterey: "0f837f9bcd77b67d3a9fcb4151563d215c33acd5dd4cb62b70efcfe08636bfa9"
    sha256 cellar: :any,                 arm64_big_sur:  "d65598c0261a2abf7747cb4275929e458ab4ca3dd43ca5acf9a1349f967d1e05"
    sha256 cellar: :any,                 ventura:        "47ffcfa230e3f502d9190dba4c2e988fced665fa2efd4524bf6db0e50a22a280"
    sha256 cellar: :any,                 monterey:       "1e0eee17c0590322ad1543c9eaad1fd3f2299d277774181aeca2d799d8e704d8"
    sha256 cellar: :any,                 big_sur:        "5bd93b31407b09d02ebde1df72901d479508d5ae80c24c01abd7f1f4e6f9845a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0719d36b10019080cdaba4022bdefa954c058a5ac1008f09561641cc950749a1"
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