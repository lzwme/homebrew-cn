class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.04.01.00.tar.gz"
  sha256 "e408a973a59a37def97a8e0ec368ee9fa39c8d49c925ecf7335f1c0463c1a819"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b5be5e1fba1d3085f1d2ebf0edd6dbe6dc2d163d2ef5c5619c3e9a0a300c0ac9"
    sha256 cellar: :any,                 arm64_ventura:  "4df21e95a19fb5d42f301ac564445e6ed5c727be06a286c8463409d825daf355"
    sha256 cellar: :any,                 arm64_monterey: "47b1d6fc67f4009c349f02bd7893936cd70a60a82fd70511b3f2cfc34aa77c86"
    sha256 cellar: :any,                 sonoma:         "5de25c309aaccdc6d67d27d75885cd2875a215d862817f91c1d2b5d77648b24e"
    sha256 cellar: :any,                 ventura:        "eb6a0e4e4117d2dca43595b1f4863661d9f3f100b80723b6e8af117884ea9561"
    sha256 cellar: :any,                 monterey:       "d82e9e875fd0d9c81460df36998222f3415891030175849bc26f1826f8bb5e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12791b35cab0e94d8768588a0e556e2c7aa4559d6c6e46f0dc0423ec7a4b520b"
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