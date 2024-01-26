class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.01.22.00.tar.gz"
  sha256 "928cbabaa25b70b7998a452269e5d53cd003b5d5fe0fb104cc5c30af4054c883"
  license "Apache-2.0"
  revision 1
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3bb05cc2f46998ca9e0d5ba7803d008d0ed06752d72c7cb7ad82328b88847fee"
    sha256 cellar: :any,                 arm64_ventura:  "4c7caa7c9010e886c62f8ef070f8510cb1d70192e2dcabdfd5a924b7c1cd6d64"
    sha256 cellar: :any,                 arm64_monterey: "3244de2aa0f845b2ca3a624d1fc909f913e0a5843223d1e7b669069c6b57e9cd"
    sha256 cellar: :any,                 sonoma:         "8f93805bf228b4ec1f4e54b79e05ed8ab54b829cf5296c9b5053ae8a61c800ce"
    sha256 cellar: :any,                 ventura:        "338bde75404ec6d851063c0f272d1fa6743691e0be4acf0fff73d7fde7917cd5"
    sha256 cellar: :any,                 monterey:       "69117f656994b0047ff907917889804e353b3225a5ec9b89c9d1460f5acb56b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e2ebfded24a27aeeb2ac7a64244fb65de2b1e531c2b3de6a84b1ac684cb9fda"
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