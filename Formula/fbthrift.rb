class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.07.10.00.tar.gz"
  sha256 "8e05cb9a337222aecd15d6c12a2242510213e3446c8e56b3b5411a390521b434"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1a9956f71de0e397d2a423a5966ba22640f0dfb240769ffbbfb1ac2912ce6267"
    sha256 cellar: :any,                 arm64_monterey: "b310f4fe4c7a26f7f30a80fb851f625c96e617773b11fe23a86f6d69cb0b8a63"
    sha256 cellar: :any,                 arm64_big_sur:  "97fc57b43e2c7f57025615692e82131a5be348b49ba33e1d463815302494ac40"
    sha256 cellar: :any,                 ventura:        "d1b34b46377dac535bfaa0bfe850aa47033e73786b98cc0bc4441c645e1e30f1"
    sha256 cellar: :any,                 monterey:       "4dce7f176f758a56dacf342d680ba481b1fa8d9dd811f8ec45e67def3216e100"
    sha256 cellar: :any,                 big_sur:        "f154f48ed51df8fedae2fd339c883560e63eaf623e0e4b6147bd77ff56b7f68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "798d08284ecf07c62f9619395ea2c4516974a7b314640088fdb2b46029b9b991"
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