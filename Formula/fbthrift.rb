class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "c939d9e97b0cfde6e8f1ad35ae481300a542d7f7dcfe4461981efc39135dbfa5"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "23f030c82ab1fe6a7452fc7e9854ae16cda9469c547b20050031a1243e0f9c98"
    sha256 cellar: :any,                 arm64_monterey: "401edb15bddebe737f9436a973338269dcdbab9d04fbce81152db3f5e24cec7d"
    sha256 cellar: :any,                 arm64_big_sur:  "bd8829d9d6b8f4e7a193792def2192df77452cc8c23eeeabad286aa45f5b8b10"
    sha256 cellar: :any,                 ventura:        "40c1800b2b062753d146d2b5c21880f7310fa3144cc654cbb513d5d6a57f66cc"
    sha256 cellar: :any,                 monterey:       "55f3a5b409de3d2ac4e25cf83b3876632b5891edb988e19cb3301c7836abc222"
    sha256 cellar: :any,                 big_sur:        "e660c231e6dc8a38456685993e00e568505ffdbd9d2bfe72a9842b2658a1269f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d56f76eed7da62834b4cf323a1d0d19ab8e26e2af6a6abaf3b9bd477b1d5d813"
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