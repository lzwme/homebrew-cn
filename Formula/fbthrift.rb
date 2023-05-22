class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "c939d9e97b0cfde6e8f1ad35ae481300a542d7f7dcfe4461981efc39135dbfa5"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "659c96ad4a00c5c2639252ddb3e71bd8b03cfda2bc572a8e8eb492e122e3fc27"
    sha256 cellar: :any,                 arm64_monterey: "4ab2e5096aa95932b4d3fa5756b6e338fb36c9577b427f5718a36de3cb4d6984"
    sha256 cellar: :any,                 arm64_big_sur:  "6b04a2556d6eb5cdff483aa477daede312ddb611f003ef2b9504154ab9bbb3ba"
    sha256 cellar: :any,                 ventura:        "eddfe710f79ecd2c43e3ff29844dd5a8b7bfc3ba242e09343fd282fa2adf445f"
    sha256 cellar: :any,                 monterey:       "a0a3748a10f831e5ed973fe578f355b555f90b74eaedd46c4e15e66794f8c053"
    sha256 cellar: :any,                 big_sur:        "a4372fcda5b62a922941b682add2041551c175461bcca4951d41fa0790538925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22bb469d1fe7e76700e7fc117104923ef7b85f8cef12fcb66695969e820c286c"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
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

  # Add missing source to CMakeLists.txt.
  patch :DATA

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, *shared_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"
  end

  test do
    (testpath/"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath/"gen-cpp2", :exist?
    assert_predicate testpath/"gen-cpp2", :directory?
  end
end

__END__
diff --git a/thrift/lib/cpp2/CMakeLists.txt b/thrift/lib/cpp2/CMakeLists.txt
index 9adf60ff54..c8d34d8949 100644
--- a/thrift/lib/cpp2/CMakeLists.txt
+++ b/thrift/lib/cpp2/CMakeLists.txt
@@ -250,6 +250,7 @@ add_library(
   server/ParallelConcurrencyController.cpp
   server/TokenBucketConcurrencyController.cpp
   server/StandardConcurrencyController.cpp
+  server/TMConcurrencyController.cpp
   server/ThreadManagerLoggingWrapper.cpp
   server/RequestDebugLog.cpp
   server/RequestPileBase.cpp