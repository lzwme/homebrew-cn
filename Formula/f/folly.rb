class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.11.20.00.tar.gz"
  sha256 "638cd91cb69f298ca1d297003933f48453681d4f68242311eb31ef2a06ee9f70"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff327714c29f2edea2394ffb4899bc83b4410ffa951241fd56afaf3d4e7b2843"
    sha256 cellar: :any,                 arm64_ventura:  "08b86973fd892d414179d24471ffe3a58d3711f7d3f5e3b28463e547d04ad8dc"
    sha256 cellar: :any,                 arm64_monterey: "74ff295c6e9592881aeddae42afa3d1d6769dd734aaf9e6f205fa999804f988b"
    sha256 cellar: :any,                 sonoma:         "b32b2b1473c9130f80b440651a14d9fd7efdfdc6c1509a1c50391002bae10026"
    sha256 cellar: :any,                 ventura:        "98172118e6a9f981be12ec756c92f79e588855620afced368316288ecc283834"
    sha256 cellar: :any,                 monterey:       "65a00988df24933384b558312e152914d7c45493471c9203706e64534c21c149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e1153cc6d506a3685137117d9a22b1bb4827a01e5323e5a0117cebf8c56f3d5"
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