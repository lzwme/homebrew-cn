class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.11.13.00.tar.gz"
  sha256 "059434230d937b897be490c3f7d21285121b83efdeb6651f2a7c10015a481df5"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3c25a071f7c1d763d733464213ff1ed9075467b1dfa04929ac12b8b28b15c7d9"
    sha256 cellar: :any,                 arm64_ventura:  "c791dc77e1fc2fe62f603aff7fb00dc4b80e124b6a0a66e9a044f0fc49685765"
    sha256 cellar: :any,                 arm64_monterey: "329983f35e91e0e2a90c51da1bcbcf19e510cd43e6ce7184fdd387034fa4008d"
    sha256 cellar: :any,                 sonoma:         "9197bac5a424895eeec58a946ac7de25767743c3224eb5b5ac78b94e290da563"
    sha256 cellar: :any,                 ventura:        "3a16e2e26d97cd860c0d785a1bd12b839ca73dde6bdd48d222d1fac25ad174cf"
    sha256 cellar: :any,                 monterey:       "5cf39cc1141825b8a7c0a964f3ec6abab45ee21ca313326f495332460e66b94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "961b7cc98cafc38551f2fbae335b22477a1346205e079931fc86b95637d2e28b"
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