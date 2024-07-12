class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.07.08.00.tar.gz"
  sha256 "5efada565a85057824c58784dedd2600a03e531d526021bfe8bb8b655f56f09e"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a24fa71ce08cb701a482b0f7ab18726b9533e92cb425db26978cea825f47046a"
    sha256 cellar: :any,                 arm64_ventura:  "a06c3e1c97b0852b8e56fd5ab90e1d3ff68e26675f074203d35bb5d0f59764b5"
    sha256 cellar: :any,                 arm64_monterey: "8089e2b48ddca1cecb50fef134e511f65525e188d451013f5756cef0084268fd"
    sha256 cellar: :any,                 sonoma:         "0f52f9587f1019ed37d56c180e6acc15c8a7a674d931300df7ee42560bd83c7b"
    sha256 cellar: :any,                 ventura:        "acc5205b9a2581a114ef568fe6c22d82e90cbc57052dad55ca7e83c08f8c4031"
    sha256 cellar: :any,                 monterey:       "136491189609333f861e09388ceb1a6c271a25d3e41aa4064a98f605396deacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da8fba7ddd7a64f21c42dd03151d6e7a235fd88b902d7d322e5bd595c4661736"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
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
    # to include them, make sure `binthrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "buildshared", *shared_args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    elisp.install "thriftcontribthrift.el"
    (share"vimvimfilessyntax").install "thriftcontribthrift.vim"
  end

  test do
    (testpath"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath"gen-cpp2", :exist?
    assert_predicate testpath"gen-cpp2", :directory?
  end
end