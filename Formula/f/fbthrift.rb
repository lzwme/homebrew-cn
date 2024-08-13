class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.08.12.00.tar.gz"
  sha256 "d6ff9d28ad25f3769ff7a02ead4a5d2f74d47f138165fcb51624a6c3585a831a"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b259aa71d4140cba0a4b484916b14ff246b948de4a86c80d84cb0f8738e2178"
    sha256 cellar: :any,                 arm64_ventura:  "227dafc7f9be5dee377a6c0a4a2133f80c80e815be4ed70644946167403ef367"
    sha256 cellar: :any,                 arm64_monterey: "4bcc5b335190c438724049686517674614dd236a9f4f581b1d98e9d2854bc5ce"
    sha256 cellar: :any,                 sonoma:         "8c958989306ed677f470438bac2884318459fb38fcbd62137ef14c2daa5d7a50"
    sha256 cellar: :any,                 ventura:        "c3ce14af0794280197b7f99db7bb81276ed6b96f0a53ac47186cade7c103529c"
    sha256 cellar: :any,                 monterey:       "361b92f764a64472519b8f71f701155b7e6af57dbca7d9c506415f8433ef8369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "532738f022ac00b019cf6564c30a6bd80e7ddbab484d27b992975d2def21d5ec"
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