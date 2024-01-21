class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.01.15.00.tar.gz"
  sha256 "bdc141daf09b8c3428ac3fe9ae1bec2ea2c07efd796721f8dd301ad61172be57"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a6fafecf8f3e7a03fc12bad6c67d5f1379c33d1f763d0306258716e86a68b5ec"
    sha256 cellar: :any,                 arm64_ventura:  "1e048d15eeef4cadca5584e8955abb74868489f1ae58e981a50b87d8f93cbabd"
    sha256 cellar: :any,                 arm64_monterey: "006db54ad97c398c4417994e86f287a0d029b7b8f73ce0db694fa0ac7ea3b2da"
    sha256 cellar: :any,                 sonoma:         "806f00630491000a641914f8ca0ad7b377626c353edfcaa720002099fb27eb81"
    sha256 cellar: :any,                 ventura:        "92902384eef1384fd2baab840020829b444ed7d77554063982933a6c11b75bfc"
    sha256 cellar: :any,                 monterey:       "ab0c5814ad197d967bdc5b6bd8a2e914e57e851963b160965e1735689c068994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8a1c739f80b93d4a28c5dc01833f4c4744c2a4abdf7c141d247bf5906394244"
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