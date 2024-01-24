class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.01.22.00.tar.gz"
  sha256 "ba8d9c84403ab71ced8d34e9fd241d0df97ef3391aaffde96f89da8b91703fa4"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d887699d3e0ae2f4774ea80c74e05d8201f00d996a592ba7dc2777470dbf41af"
    sha256 cellar: :any,                 arm64_ventura:  "a370c2e1ec2ceab669f11095097d5bd3b8eedc216a08027dc90a3eaedaec443f"
    sha256 cellar: :any,                 arm64_monterey: "560637db5caaf8bd9558fd6ff7b9ae511576331fc0ea8a69035086f90ff51bda"
    sha256 cellar: :any,                 sonoma:         "6f992775fc770af3053d7724678b8edeb6eae6d6c7864758d9b1ab5eba23c3ca"
    sha256 cellar: :any,                 ventura:        "ddb54cb1ce7752121bad4e7f38cc61726855bfd064575da4a22be10834b259b1"
    sha256 cellar: :any,                 monterey:       "613242fbcff34cde0406bee585de913d45ac05c294f473fede87b4257dbf7025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49676067ea9feced3dea332aa130de8683b925cb225124da740793ff63cbc825"
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