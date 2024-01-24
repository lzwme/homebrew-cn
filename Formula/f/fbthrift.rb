class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.01.22.00.tar.gz"
  sha256 "928cbabaa25b70b7998a452269e5d53cd003b5d5fe0fb104cc5c30af4054c883"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c648e3985494137bec7d5d52ca6ac729fa8b1d148c62c04f49dc93620c98286"
    sha256 cellar: :any,                 arm64_ventura:  "0a20f5bb3a43bb1e2cfd9b70059f9680339ac6787eb3e3be264f9ba19a033012"
    sha256 cellar: :any,                 arm64_monterey: "d088c2884c58e651af286828e27f95061fd7b884cc028f729c942bfdc3e86a69"
    sha256 cellar: :any,                 sonoma:         "1676e4c60e52036694d403ba3b35fb46b4da579dda88d89c8ae134991991dd45"
    sha256 cellar: :any,                 ventura:        "ce4b820b89b4b6320e2f159d28558a5bf69afaac0bc4d20b5b37b094aa7b49ae"
    sha256 cellar: :any,                 monterey:       "3c271057b6025cd5c950089d57985fa161fea816a5e8c8590bc3514308216ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffb88ece3c3c966692fea0deb967e03a57e5f69d39ce28f2243565a4254a82b7"
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