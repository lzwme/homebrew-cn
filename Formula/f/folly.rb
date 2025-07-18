class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2025.07.14.00.tar.gz"
  sha256 "0bcb9c2ba00fe56fb0228c9a663e5a08414f59b3430e0f9f8724af0ef6e7df56"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "afcfe7b331345b2b9908522044174e2952d9439a3850f2346472548c2995928c"
    sha256 cellar: :any,                 arm64_sonoma:  "8e0e91bc0644a6ead019c89d4d72ec33f8066b0565dd9eaa3f8b1ab78fe4e063"
    sha256 cellar: :any,                 arm64_ventura: "7914c6b471e193463f6ec13eec3077271133f6eee4f5f720b4c61190ff558169"
    sha256 cellar: :any,                 sonoma:        "8518b143644d44b8b206530913fd9cc5c1904af137d35feb544349779451c702"
    sha256 cellar: :any,                 ventura:       "a99810b38c505e18fc68f5c11995437ce67bfcae04ffd3289f3ef0612228b96b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "447cbfebb16bc079b4830a759d2dc288673df9bd51637a89d1bc7508aa215622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d68b793e8ed43c55a6200ae08be527cef252583c6ced3c9de2ac0475ffa9d8a"
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