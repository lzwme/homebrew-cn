class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.04.24.00.tar.gz"
  sha256 "5fd12c95ebe81babdcea56e0de58d76b885fbf244e1c640a25be259fe7734e69"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2701e6b8ff4ece730f09cad09b63f50f18578d45adf327933bdef51de7bd32d9"
    sha256 cellar: :any,                 arm64_monterey: "5b92d14a2f09ae30372aa5a0f9d09b0151381c35807d65f6242eb24cba82a7ff"
    sha256 cellar: :any,                 arm64_big_sur:  "b77e2690cf2415294e40cfe93f87d32406e86051e4f36147b51bbbad1a612d82"
    sha256 cellar: :any,                 ventura:        "5886629c194355b3f73b06804bc7061d6bc31d8f7b664052060226e85b5ca2db"
    sha256 cellar: :any,                 monterey:       "65646eb2f04779ce5f79aa45ee01d9ae51a8154de5793a0aa463062f35541474"
    sha256 cellar: :any,                 big_sur:        "a0d8b6c66e524461d4db86cbea8786a381c1afbf66d2ed9c352f2ced49cf792e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65033286f1bdbdb3a58fc725381a4471848b06b9ed314f52e0e2459f9e6137de"
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