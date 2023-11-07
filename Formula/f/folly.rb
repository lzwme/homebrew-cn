class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.11.06.00.tar.gz"
  sha256 "99f5e2a885da4d9717d026f85ff83c103732c5741138414d20d684f7b72e777e"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8fbfc9c391bc66cdeed45313cbfba111f8f1786844b07f851c2930775e99f1a0"
    sha256 cellar: :any,                 arm64_ventura:  "8be8acdedaa7efd4e030a9b812c9efe65a7590ba8a8048de54c0e739fa984dd0"
    sha256 cellar: :any,                 arm64_monterey: "12030620ce081a17f231f48631be2dcd8869f4baa8fb49e9218dff7326585c24"
    sha256 cellar: :any,                 sonoma:         "01767b38ad916e08aa6235ef60d0a7210a688625b6ee60d01860a4979b0fb450"
    sha256 cellar: :any,                 ventura:        "446948c92c1b99633540d8ff4f5eafc8e1395f151b355b16d055646bb170d616"
    sha256 cellar: :any,                 monterey:       "29bb99abdf376cab1c25439603745477bf3ad4b7d6d48f99722c5ccf3ee29c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2155372eb81c534e1b23d3d41e88b35c4c695d4988d5458a50a5cca5898579"
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