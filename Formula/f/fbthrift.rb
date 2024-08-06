class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.07.29.00.tar.gz"
  sha256 "5501a185e449315a119219aca1c96423b0a29953587c3bfcbb7a72af10fbb06f"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f4d0fc1c435ff0f6eec9b19dc5e3ec18df475b5cee55d7d68d9533271269f125"
    sha256 cellar: :any,                 arm64_ventura:  "9d88f644f5b9fbffdb3843ab7d037dd8dd72b036e8c85649bf06e157c8f1b4f0"
    sha256 cellar: :any,                 arm64_monterey: "df09738e277dc7f1be49910b86ad9cb95de5b1d90c6f371899e254eaea6b5a05"
    sha256 cellar: :any,                 sonoma:         "c5973f0c88c243cf974d1a83c824b752ddfedb394a13d2a46b435cf80a209bc6"
    sha256 cellar: :any,                 ventura:        "72e76be2c8bf2b5df2b8a3aa16d038b141e27e6970f34fa3cd9d524c90328cfc"
    sha256 cellar: :any,                 monterey:       "d8fa8d72db7ed089add2deb3dc14d56fbea7e3aa8b188fdea86d06fd7ff5a96b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab3ce1f59b5f61d8bd840e67371d71cd42892fb9a98431de41f273fdad4a672b"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
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

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `binthrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "buildshared", *shared_args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    elisp.install "thriftcontribthrift.el"
    (share"vimvimfilessyntax").install "thriftcontribthrift.vim"
  end

  test do
    (testpath"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath"gen-cpp2", :exist?
    assert_predicate testpath"gen-cpp2", :directory?
  end
end