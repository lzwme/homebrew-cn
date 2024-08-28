class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.08.19.00.tar.gz"
  sha256 "c6d92a0c671db2624a6a7da004ec4060503039b9e222cd210bb16069605125b4"
  license "Apache-2.0"
  revision 1
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f500b3f748f7355da3b6240e491b7cbcdfc455877d3d3ff2816b994e6fb2a178"
    sha256 cellar: :any,                 arm64_ventura:  "01f744c8183d4eaeca39c3195cb9a2405c76e64b9007ddf77581585b19871133"
    sha256 cellar: :any,                 arm64_monterey: "e50bdbea95955af5fb3eb1edeab45707b4a6c676a59df3cf3874af9853314c31"
    sha256 cellar: :any,                 sonoma:         "60bdf8d5ada07931d39492a2920d4d1ef49de0538c94ef39563831fb917f4838"
    sha256 cellar: :any,                 ventura:        "d6b88bd1bc15356e8c3d757b29174d155dcd6b5b69d6bdea10748b417791d687"
    sha256 cellar: :any,                 monterey:       "672331619013f6df9e70397d4a11b5e1fa781c04a905f9aab4949f95ac5e1025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b98b20981c6b221b5eb659e8e78d6b17aaada662b479244eee1b17489412bb44"
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