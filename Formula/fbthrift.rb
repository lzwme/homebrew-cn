class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/v2023.03.27.00.tar.gz"
  sha256 "7e5efab2d3d185845ac6dfea68af990bc6bf37bb6b344374f9dee7e87497fcdf"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "932bc4783e914cb7da565ba60f59d277e6685758c0a20651d9f55c46128bd9c2"
    sha256 cellar: :any,                 arm64_monterey: "525776b2b920bf262d21e7eb6ecdebf4950b0a27a7f1e4c793b90995d70547e4"
    sha256 cellar: :any,                 arm64_big_sur:  "b2047b1ce35efb5f7805efceb327ae451d1b1932b8803ab99a4463ccc1bea6f4"
    sha256 cellar: :any,                 ventura:        "8f9ec942df55c4fd5aeb5dc40bfc061411b62ac61bbb16f72fe6f13a86eea088"
    sha256 cellar: :any,                 monterey:       "b8438c6e048db0c276771f2e4b958271a969ff2807b4cec1341d48ac19ea1a2d"
    sha256 cellar: :any,                 big_sur:        "80a9ba2a7e66601383cae809a0917edc8352b97820b5ed97068a5e2a2d392e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "059ca7467c6fadd004fd94dc2525fbd7b09b7f179bc8a266850a1f0c5e0f0a5c"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
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