class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.08.05.00.tar.gz"
  sha256 "11aeddb451ff0dcdb79b65392291120711c3dafb431bb26c2af3bab7481b6a4d"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3f57ee07f269c6b2429b0e6274b742b0f7907214a824792c1d172d642fbfaeb"
    sha256 cellar: :any,                 arm64_ventura:  "382eca282967319f91dc806aa79bf7b9860700cbabdce6f66c3fa70e2a22364c"
    sha256 cellar: :any,                 arm64_monterey: "e69f43326a304e3d9634ae11525f9abc8d18ecd7c19d98037f3810ca545c6daa"
    sha256 cellar: :any,                 sonoma:         "4588160d3db70489bfdbc00976d0ca8c41e7dbd5c2a36af86f0b01d1963d3427"
    sha256 cellar: :any,                 ventura:        "3713f20cb6b2080ef52d3898d5dbadeae26f9c1e0f6e8d9f4d9d1787cf82a254"
    sha256 cellar: :any,                 monterey:       "d23874ed990efe2e1242ab12fcbdd742f9984e5ecec8688ce7a221828e7fc6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac9da50a9b8fac462f0d584406fa0dc8e279de19099706536e4db60ad7700d9e"
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