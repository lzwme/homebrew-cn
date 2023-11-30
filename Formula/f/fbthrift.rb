class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.11.27.00.tar.gz"
  sha256 "9cc7bc6ad34cba21cec30d25f2243551a489ccabbb0d72e0c4bfde43433a50ed"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e0e4df5979f794ad89d139cfb3b10e33dfe2b9d9a6413233b7f88347522a071e"
    sha256 cellar: :any,                 arm64_ventura:  "6a41e8ad21c0d202ba1026ae39893d56883f2d950ffca6681e77ec64426ea950"
    sha256 cellar: :any,                 arm64_monterey: "efeba0e005247b0fa45bcc81e75b80c2541481a24a3ea1bd20b760a2b6d66197"
    sha256 cellar: :any,                 sonoma:         "3cd3b8bd39c929780bbfe2da80620c9040a96ce7bac7202780bc88eaa9b5d054"
    sha256 cellar: :any,                 ventura:        "8a45d2adfd11ef0e66e7d08f20947f544d17d3b930a7636ee12c1a031e938a0b"
    sha256 cellar: :any,                 monterey:       "e3fe4e8b2e18cf183d225d22293fa1badc01bacc4a337e5bc6789b26b128b0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbfc1988fe8e31b90edcce8b548aad67a65848c58e2cccd69e4b02d876230954"
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