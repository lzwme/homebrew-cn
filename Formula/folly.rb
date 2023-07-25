class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.07.24.00.tar.gz"
  sha256 "a07d96c6465d9cc3446dad19f8684701d6d0756a15a1aa992b6775c80df44ff1"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bcce00fa3c664bd6c122ab1b68f90f7c578c6e584fdfbf400491ab141c422e97"
    sha256 cellar: :any,                 arm64_monterey: "8673dde5bf9dd7ff88bdad424dc246abc4eb67df36193129d36a17973d47c19a"
    sha256 cellar: :any,                 arm64_big_sur:  "1f9f3da44f670fd33e855298b88e41cfb389eb11d9394381c4a96f4ca0261db6"
    sha256 cellar: :any,                 ventura:        "160bedf81df98d41ed1c5a3d487d468e439b70b61a383db6740b6e4c42f0c6ad"
    sha256 cellar: :any,                 monterey:       "4fdec10a2bd2c50918e0b1d26b9d8901d13fddd5cdb7a2117378bf2b68503550"
    sha256 cellar: :any,                 big_sur:        "d81b17b5f2e028eb26bcc300ebda15a0c72aa8f626d834fb665377363e32c0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f2c1b6814a2ebd61375cba805eff4372764dd1eeeed54811da70951d69945a5"
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