class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.10.23.00.tar.gz"
  sha256 "87c6dbc8b37190ae0030f06c029de1fd83f9aab4fd53d7fc67d16be517e7c50e"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "10e9cfdc59a7344c609931e3ea2ceb50af9445fb77d026a4a1cdd1a28914ca47"
    sha256 cellar: :any,                 arm64_ventura:  "eab2ef9e93f287f6eb9522f97b04d262f28a8d68dd51c2dc8315ef3544ce469d"
    sha256 cellar: :any,                 arm64_monterey: "c575b3fbc892b4f51aa09243fb3515bff7ca50cd7442a3cf979c983c585d9df1"
    sha256 cellar: :any,                 sonoma:         "6bb7f873fcddc14f2e8d9f952a1d9dbd6e903b5dfc6e70fb71a53755fac75e49"
    sha256 cellar: :any,                 ventura:        "b65bedc1d4fe17810d5c920587b85c4d351b854c14eaf787c7cd3cb655aa9da5"
    sha256 cellar: :any,                 monterey:       "1eae45a26a15fa4fdb26bb1c158604d7edd309c9d56a6308dcfce472694c0f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb6e13c28a7b5973aad63028dab18d4b3d54213bff74b4bb56481be2b06550e"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix
    ENV.append_to_cflags "-fPIC" if OS.linux?

    # Setting `BUILD_SHARED_LIBS=ON` fails the build.
    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"
  end

  test do
    (testpath/"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath/"gen-cpp2", :exist?
    assert_predicate testpath/"gen-cpp2", :directory?
  end
end