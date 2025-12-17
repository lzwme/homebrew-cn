class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2025.12.15.00.tar.gz"
  sha256 "921c4248e53deb7d1962c93ef0536ee3aa0e8fc649b2bd80cd0c4476c5e16cd5"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "386b7ce9264ae8aec678e21f1f8751a24fe3dbbdc27a9c931c5782f42f756e65"
    sha256 cellar: :any,                 arm64_sequoia: "efca09a63c8d4c8ee1960676239eb7ebf6823eacecf3dedf8a1b76db15cd245f"
    sha256 cellar: :any,                 arm64_sonoma:  "ce0ff23415d91a35ae86cddaf947de05d22d899bb125cb15cfce8f8474c58eef"
    sha256 cellar: :any,                 sonoma:        "e34487a13d018bb6c3fb7c1fb93cb2a83f371e8789ae85c4b2abbd6ae035317a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a07a72735dea34bf16491f17885a979c19d9131c205ba926b9230089ff5184f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6b14764977d2605d84956cb17c76a4d8bc7e6ed522128b3acfec8c09fead97d"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
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
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

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

    (testpath/"test.cc").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end