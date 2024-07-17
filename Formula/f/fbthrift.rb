class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.07.15.00.tar.gz"
  sha256 "2671ebe49d6d379cc0f43c95c08a173fd6da6f04a9f748acdcda4d7a185f27f4"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "825a68144f241ea307e17e5c4e61d637130f53112065bbb509395647b7b00ef9"
    sha256 cellar: :any,                 arm64_ventura:  "c27c2ddd8c9a43a7cfb317d8fa25bb8d39c2d7f1789e7cdf021845e0c90e33cd"
    sha256 cellar: :any,                 arm64_monterey: "28644aa15d724074c0fc93c9dbf2857ed3a18cdaa141fb4e49a8aba4f4108617"
    sha256 cellar: :any,                 sonoma:         "edc893e4c718fba104781b04be89d2d796706cd71796d2b856be5dd97b3ca40e"
    sha256 cellar: :any,                 ventura:        "acade33d8d82f3fc1090d2c02b74d480876020343db2a35ad57ff2d19069cc49"
    sha256 cellar: :any,                 monterey:       "ee48b29f1bf60376892ac5b06bd10631c870ddb73ea3faa527c8623a7209a634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f58e111c2549df985a6ab78047a83301e582a23cf1d5cc4032147a756716309"
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