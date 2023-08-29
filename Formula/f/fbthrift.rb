class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.08.28.00.tar.gz"
  sha256 "74b85df373ba7e56bddd51c881a9acc4932e7e6e130e5990ba5b35de845192c6"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "65686a0adeeb3d871c08ac5987968daa14e2fb8107d58c934ae5ca478796103d"
    sha256 cellar: :any,                 arm64_monterey: "32566681c7c6c6e57b0fb0780b1d0957ee8f65058368f0aad078f778b84a117a"
    sha256 cellar: :any,                 arm64_big_sur:  "8fda83d21a2c0938a6ebb540a0aaf82ca4846e58a057a38928b053aa036b4fbc"
    sha256 cellar: :any,                 ventura:        "1aff98308fbd0dd2a55a75c180c61ad7ba1950aa979fd1f446273d8bca518a61"
    sha256 cellar: :any,                 monterey:       "6e220144f2febabb704c61964ac90bd72aa42b3401bcd525527b3bcdb43bae51"
    sha256 cellar: :any,                 big_sur:        "1ba6ee9ec090ce2fef8b3ebb8cbc57caaa9e2b7cf73041a54bc8935d07e0f533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09cf61a66cc48782be4b8f6d4d927d832844eed3db99df062e8c719b5dad6bca"
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