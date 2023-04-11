class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/v2023.04.10.00.tar.gz"
  sha256 "e02e15a245c05f21a0dcf2357bc67f50c175e57ca746782da166db688241c74c"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "365c5bc659087b2735108c10547a30699ea92bcb745713af770967a42755d806"
    sha256 cellar: :any,                 arm64_monterey: "24e5899de5c2a27fbbc2e4f98841d258e1f114131d504103822f7af822bc2c15"
    sha256 cellar: :any,                 arm64_big_sur:  "c6f12c6859176684f9e23a3e3742733d519396ed88383bafdc4ca2306677fce9"
    sha256 cellar: :any,                 ventura:        "a8c6e039a417d24f1d2310764cd9dc625b023a8dc842cc32b72a09cb728572f8"
    sha256 cellar: :any,                 monterey:       "19a78855ecb12c135c4fdc81d26697d8f8ff51f11467b611e2ab12a56d639318"
    sha256 cellar: :any,                 big_sur:        "257969988cc85454a5db49fbe9b3df401850304f6ef4d3b65160d882bbf78f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20da8089cbc76ae2acbd705ff7d9256f2f31c6787a51dece1e2f7fd14cf19138"
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