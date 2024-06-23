class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.06.17.00.tar.gz"
  sha256 "6a45cf7e644d4850e06b44cd1c499167a9a2c5186b3ac806c8fbc7eb5ee8015b"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91e5705647f92966193fbd8cb99881990cee0445d9a76fb5b0ca49b525418e64"
    sha256 cellar: :any,                 arm64_ventura:  "012b18039c6af0fb0fd46efb2643a454c10591c4c2a7b539119304bdd11a8069"
    sha256 cellar: :any,                 arm64_monterey: "1d59f9ce0a1d82e2e6967cf2785649220ee421a8532abc626ffaf8473239ff97"
    sha256 cellar: :any,                 sonoma:         "7c88451edf4aae155f5590882af47c7b5d4ee71f84cc8128daff379ceb441e7c"
    sha256 cellar: :any,                 ventura:        "4fad6de47aa9abb9109a5edee9e3d5814a6697043a59ab43eb9b4d9fc0410b99"
    sha256 cellar: :any,                 monterey:       "8a75570368b1d32fc5b7303f35b2941a718c0224a517af288e98aeeecc9aac0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3708f7b0066c40c090f4f0f512f5bcb877764e046fec85e15371053a888ecca0"
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

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https:github.comfacebookfollyissues1545
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

    system "cmake", "-S", ".", "-B", "buildshared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", ".", "-B", "buildstatic",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildstatic"
    lib.install "buildstaticlibfolly.a", "buildstaticfollylibfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath"test.cc").write <<~EOS
      #include <follyFBVector.h>
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
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system ".test"
  end
end