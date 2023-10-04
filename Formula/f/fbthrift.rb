class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.10.02.00.tar.gz"
  sha256 "8c0a9e9f4bc98566673bcff00eeae7031968ae68dca24903fc721b6b13a6977a"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "05b7949fa20916580d38f7e4c95a6f1acfe8edb4c58a43170f93aa889f53fbc9"
    sha256 cellar: :any,                 arm64_ventura:  "735cfe2f1b056a3d914bd9b180b920b979acba9fa5dd00b70352d98950fc37c0"
    sha256 cellar: :any,                 arm64_monterey: "7b0697a84faace3f30424040dad9879364703501a7c692d7850bb946231a102d"
    sha256 cellar: :any,                 sonoma:         "a0d940d58071dc003f5f6f0a1fc60acd81462407ab7b42ed4b2fb4cf4651ed96"
    sha256 cellar: :any,                 ventura:        "faa97cbf7b50a7a91976d5f46c7b19f9e94e931f46a272d6e9803a352399342f"
    sha256 cellar: :any,                 monterey:       "e9fa3b6e68ca8807de95ea0ca14fe659b22bf8d467e3326b0f25b3d57852c4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a878d647524d70bbff8c6d93d964261ed4d2b30222c04b410b60a6c4db3452"
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