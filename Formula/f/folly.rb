class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.08.12.00.tar.gz"
  sha256 "f6229c8b564aab912ebb8b9d7329c22865d20b37800408efa4e0166f630fe733"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "281256a7cc33f8a1b56908a66fe02e16474df8c2329e0ac4f1b8f0f476d333eb"
    sha256 cellar: :any,                 arm64_ventura:  "eb074a141168e13fb79f55dbc1bf90d7853df8ea3cfd3d702a40481b65018fa5"
    sha256 cellar: :any,                 arm64_monterey: "dc751c16d38ac6e7525ef02c6891c90d6c23312805bea0407d28dc89d02614c8"
    sha256 cellar: :any,                 sonoma:         "b5c8f0dd72c45305c078765ae5352ff080138889c7cb9327269b5b01f0c97e8c"
    sha256 cellar: :any,                 ventura:        "ff927c7bf063f03634548b0f427370dce7a6b691c50ad97f51a128506f6f5c39"
    sha256 cellar: :any,                 monterey:       "ec3444f26424b8fe0ef9a33bbf8601d2a2aa0227314212ef42ddc58460eedd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd5aa20cc86de558644e8fa1dbb7938df08b537a60936e4e0888abf433dcb3ed"
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