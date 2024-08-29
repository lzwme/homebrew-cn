class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.08.26.00.tar.gz"
  sha256 "e763819b98d8e8b40ca49cdc0efdce49ea745cbd8828ca5df98d6bf217dee9d4"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f784764e407e6961b0dffe027b5104a371ccae8bd849858059a64919eae7af3"
    sha256 cellar: :any,                 arm64_ventura:  "ce9fe1d94d053cdadd9d8f7d3c371575a094fb77614f468d25b7845508e7cf6f"
    sha256 cellar: :any,                 arm64_monterey: "65847f91f2e6895b9c8adc3e21ce60d7c9ee2d46d19a19b50fdf8546b5b77847"
    sha256 cellar: :any,                 sonoma:         "bb36a70ff88cb8dc2baf1c42b12ba644747e880a7c9acb44356e5dfdebc7b2a9"
    sha256 cellar: :any,                 ventura:        "3d640b4a334b90087fbff538b067bf7bf934ba04dd4ba1aa97825ea810dd671a"
    sha256 cellar: :any,                 monterey:       "a8cae93fc79eb849c715ac7e007042052256bdc051d0fd55c2dc9f114e381c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54c15031e2cde81d434d03422f2c8efcd96f80036f5d406827f74b2cb35994e"
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