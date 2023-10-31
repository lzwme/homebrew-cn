class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.10.30.00.tar.gz"
  sha256 "77ca023936de6b35bb1cf8bd45e9db58ae79f53ea4acdc30dc717e454c500ef3"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a41e21c2085940b601d8ee868dbb2723f2c21dab802c7d67d1ecb18ffde44b3c"
    sha256 cellar: :any,                 arm64_ventura:  "b883d7199670e2521cec702b21017111c90afb507a90dc72b3162bcabe4ac4c9"
    sha256 cellar: :any,                 arm64_monterey: "f8dfcf1ec0c0f999eb352b34f75d8e2e1e84d2c807c39440e359abfbefebe2de"
    sha256 cellar: :any,                 sonoma:         "a406a9495ffd8562c56ffa61eb5ca93d2e83783bfe8f7e60b8e0dfe5929eafc3"
    sha256 cellar: :any,                 ventura:        "70d91c723b43dbb9178f2004a8210174fb61448ff6dacbf65cdb9971ac996c91"
    sha256 cellar: :any,                 monterey:       "686aeab65365787d8b7004843506c77c7b5e3da9ffd15a2845babf8350c088c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e10ec7299a728adae3284f891cbd746a5cd87b62fa67fd75a6b5b4a165d46f1a"
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