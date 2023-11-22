class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.11.20.00.tar.gz"
  sha256 "5800e8fd7204fef6885e37d08cd330fd963dd52c85511dbca820974e48c11711"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "36da092a5ae4959362898304381df2dd9f004c3d4bebc1238601531d2213e032"
    sha256 cellar: :any,                 arm64_ventura:  "bab22eedc11289d0119cfd91de570f3265e82e4770a0cbd2c4eb03598ad3ff3b"
    sha256 cellar: :any,                 arm64_monterey: "6d624932365484feff1bf05660ea89984ce4af2344ef3dc87b5132945226d479"
    sha256 cellar: :any,                 sonoma:         "3ec705d8468f33a94bcededf9e7313f2226de91f113234fb0fb7f33d25a3703a"
    sha256 cellar: :any,                 ventura:        "bfa9edc72063982fac45330e3656be304e9ae475ee7641555ee3f3f92f951a00"
    sha256 cellar: :any,                 monterey:       "035d047239e6ed8bf6ec5f484b65ba5243a8914c3061c1e67b4f648265d3e5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8211908fac76697023226f939e41d056b69953dcd0d019b24d6f22ecc6009a38"
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