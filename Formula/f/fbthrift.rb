class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.01.15.00.tar.gz"
  sha256 "e86f2e0b4ae117dc0bf3016df5e1d66d40f3c9bbd2bb602151524b3df5f4860f"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "229c8fe4aadcdc3b27c2b20c5748698972ee36f1f56fec2ed91cdb07cad3c342"
    sha256 cellar: :any,                 arm64_ventura:  "6f0622303b573d5589b41479d1c10fd90bf1133958a3cdd80be02015ee8f6226"
    sha256 cellar: :any,                 arm64_monterey: "44ff85cb7e7432a6225cd7f2c890fe585bb5e58b5fcc5decb05170eac7c873d6"
    sha256 cellar: :any,                 sonoma:         "b14ff1a0dd79408415c2f6862d9b8b3edf57580f33287161a9e515a8fbc7d615"
    sha256 cellar: :any,                 ventura:        "a00d05b92a57f7db22f83f21defc8f431f136befc8bca9a91f22fb67f3dab474"
    sha256 cellar: :any,                 monterey:       "c90950663d0a2f5fae4c4c495d9defc9aa981f2c2259605dcd177aebad8bb498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63d0aa8d205dd56fee73e2a1cb40d738bfccabaf10018870418db29594a91429"
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
    system "cmake", "-S", ".", "-B", "buildshared", *std_cmake_args
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