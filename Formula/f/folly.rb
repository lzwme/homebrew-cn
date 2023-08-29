class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.08.28.00.tar.gz"
  sha256 "6b774054d987e0e34432d6745a10c67db8d43ef4a6d841328ad8eb35144c12c0"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "78c9dd1d4fdc805c7d8298b74b9e7def0c5052cdc68db8fde32411752a4df1cf"
    sha256 cellar: :any,                 arm64_monterey: "8c75618bbd5c5651fee513e4c9c9f0380aea1c85472cb6d45cf204328c97f93e"
    sha256 cellar: :any,                 arm64_big_sur:  "3ccfc326080f84f35306bf9542be3cfda44cae2575e03805c2373398ba98e993"
    sha256 cellar: :any,                 ventura:        "363283ba3c28359cd50489e0032fad863f2ace55bbaa3e1c3d383beea268c2db"
    sha256 cellar: :any,                 monterey:       "13befc8e51ef6f3edd23ae93b93ae2b1f50a6a505ee54d0e96595619f9c046c7"
    sha256 cellar: :any,                 big_sur:        "126587f72c0a1bc6f614c1e43d5d1a63040749308ff2727dba09c1207ae047eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b03debfce66a4d37b133d440a922cb12d95a57224dadf7653069c52b75db9008"
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