class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.04.08.00.tar.gz"
  sha256 "6a0082f49a22c1dbfa4248c37703922a1e5b0efc7dcc952191f91d4ffe24b22f"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e3d87b550c40452833415dd25e3f631c5958983f6d0bb1c0764480eedc42caa1"
    sha256 cellar: :any,                 arm64_ventura:  "0924bcf8e55f7d0d0d6c21363d04540594dfa4ac1e49fa11ab7928d418567f73"
    sha256 cellar: :any,                 arm64_monterey: "33c883c9d184b8846c37b18baefc7aa1cb6a9c6ef0e3c019efb7453842d83f9b"
    sha256 cellar: :any,                 sonoma:         "affeb206429ccdd583f1acced06f8838f58dcb70fa479a2ccbde30cb8a3b9f4f"
    sha256 cellar: :any,                 ventura:        "882ebdaa4eaa7932a22a3b38795ff5333184c598f14ffba598a1e30fa9f49328"
    sha256 cellar: :any,                 monterey:       "9530810aeec029e35fc62bd492d3a99247af0a53d04c46568cd67beff8a39be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dcc20d7c9490dd77dda0a57922f974ffd0ce9400b239a88bf980f3a0a70c98b"
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