class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.08.19.00.tar.gz"
  sha256 "c6d92a0c671db2624a6a7da004ec4060503039b9e222cd210bb16069605125b4"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a9e76b988914702d72570df6c67b2b002004be94ef81242f57743595f9aca39a"
    sha256 cellar: :any,                 arm64_ventura:  "a9274d235af005e827b7e8a33592a0b17fe7d9571b939e2909197aa805a753e8"
    sha256 cellar: :any,                 arm64_monterey: "f40f47b5cd07a5d8e040bf78cd339ccb1c71d8bbc2db9aa7837d41fb515a962c"
    sha256 cellar: :any,                 sonoma:         "d6f92ec0be38d43d8e1faeb9e80a59695c2028724928c7655f37f5cd052e9c49"
    sha256 cellar: :any,                 ventura:        "3a66cfb2353687e7fc711aa0b0f34bb1ee14892248350067e1556c943fa22043"
    sha256 cellar: :any,                 monterey:       "a8d01cbbe0c87598b56a6420d43494ed1f6ea2ff9a000514a24564465abfd878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f41c4c42448af7224740520a92a7af259223d913d7d14aa2cb5e714c7c4c6db6"
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