class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.11.06.00.tar.gz"
  sha256 "4b4037fc9d16e3affe565ac860111b4669faeca63f009d6f81af5633b52f1d2c"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c33df7854f10f556af41c894c38de1d002531cf66bd4796f23614640fbc3d97e"
    sha256 cellar: :any,                 arm64_ventura:  "0e6651eb42620583fba412ae28ce60ccbf5db201e40a29d793a15f401d0f9f74"
    sha256 cellar: :any,                 arm64_monterey: "0e0ad8d11049087cbeabfa62cfea331374f6bd960d7e4b6f7ae1300c493cbd97"
    sha256 cellar: :any,                 sonoma:         "ee14f328ca6667f759c9fed8f364e6b0210a0a7b9964c7b8b72815734de254b8"
    sha256 cellar: :any,                 ventura:        "b40e6ef7f0367ba5af93c3128c106f5ca96fd3368851303a98552e7952e9c412"
    sha256 cellar: :any,                 monterey:       "cbfc34827b6c776fe51ecd1aa390c081aad7f887ebd6d92afaa4a8014ec6a2a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcdfa7213cc7b7697c81736ef0c32ca233f26cd15ac8c97d25bc61e4e846d507"
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