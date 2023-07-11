class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.07.10.00.tar.gz"
  sha256 "8e05cb9a337222aecd15d6c12a2242510213e3446c8e56b3b5411a390521b434"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "37bbd7bdef3ab5681e78fe0e95aac5ea08373912372e6f8c49cbf89a1f3533f5"
    sha256 cellar: :any,                 arm64_monterey: "f95e0930541c576c2017ac6d5d5631d84b0f0e931f31b78cc709790ef035be66"
    sha256 cellar: :any,                 arm64_big_sur:  "300f940b2237fe11e97a5b857e3493e0ecedd2e218f47ac2dabfb68dda0d89b7"
    sha256 cellar: :any,                 ventura:        "1daad547ded84ed604cb7387474dae47032d0dafa8625fc6b5f946b69d50ca08"
    sha256 cellar: :any,                 monterey:       "77fba0e40d6b5166c495cb7f9abc4e80c101a96c6f8788299189cc403f39d207"
    sha256 cellar: :any,                 big_sur:        "bdb239d89cdaaefa7d4e346d553f8351ba83b714ab780e684d1ad52d1d6109a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b24aa4f74363cd1c6676da3c950723fc914cde869b605997580b035971b52c5"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
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