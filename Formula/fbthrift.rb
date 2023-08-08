class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.08.07.00.tar.gz"
  sha256 "3c4a2536c847b137478c6c41b3b8585515a00c0f67fa7ab6a745ff3114a719b0"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f78d1cd57afdde4656957144f282e0b776166e54999bc59afefafd701f9cca21"
    sha256 cellar: :any,                 arm64_monterey: "384b8f70e16e657f8bb3927ffdc9daff0eb3c76a32c0e02a9b023a1602722ac3"
    sha256 cellar: :any,                 arm64_big_sur:  "b362bd75f3447be0805b3f31271b8b4af4bd1dd80aaf4166d54228a5501a8091"
    sha256 cellar: :any,                 ventura:        "176059a4934d526394e45ae336092a4ea67a831e4259615e149fc53f8911f1f5"
    sha256 cellar: :any,                 monterey:       "e39c5aae7d78a11bf747899d350f7f4d46e1e090af71541cd9f0032c6a030312"
    sha256 cellar: :any,                 big_sur:        "05f7fbe4ab0b75fafbf513d355b0226dad4b15ab35c0f86e60033f7d0724460d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453dfc9e457a79db66f156041644729ccff34b3e467fec7500ce244bf9ca0372"
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