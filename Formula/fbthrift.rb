class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.06.12.00.tar.gz"
  sha256 "bae7c64b91e80a1d881e7e33bbcb603542af5467ddd596c21cadb76e868c6d96"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b1f271c7ebc6d11a6c60d2513e7da57d630d948ffa44efc96a493d2ad9dedd3"
    sha256 cellar: :any,                 arm64_monterey: "0c0aa74cd15982287a34addd32da736580484d39d8a14552815801373706bc8b"
    sha256 cellar: :any,                 arm64_big_sur:  "83ee07b2a9728881d80221a962fe1a25303b31db31f99b92415e36b72e96ecee"
    sha256 cellar: :any,                 ventura:        "881aa18b4a4773ae8728dbadf660776f31847bdfc986b744f030837a0f7bc5b4"
    sha256 cellar: :any,                 monterey:       "77b5dfd5da8fba2a6445473a5ed53c9331751fbfc385d95c781aad08ddcfed42"
    sha256 cellar: :any,                 big_sur:        "c74a3024ea2a92c106719f046c85be547996d5725ca5f2cbecc085ade451dea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8099bec533d257f8c8ff5d27b689ee59e628eef4d902d1adabb30d094e6cdb61"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
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

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, *shared_args
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