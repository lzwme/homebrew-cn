class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.07.24.00.tar.gz"
  sha256 "92d4920338af200138c3d12d2757145f7ba1b2888bfbb10a7676ccbff03a0a08"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c6334fa782e693d39ce9691f7c4249104e7cfd6424cc6c56ed167b82b40c09ab"
    sha256 cellar: :any,                 arm64_monterey: "217812a7cf8b12dcfbc92ac61b488c38b314c5af583b707452955f0408707445"
    sha256 cellar: :any,                 arm64_big_sur:  "62193ae469f59d9de52809851b9f6ab301b2adbb3e8d505ee43027c9cf75a181"
    sha256 cellar: :any,                 ventura:        "0c4fd676d8524cd5c0afd1d72166707070eb3b71a42be23befd9fe96de3b61d4"
    sha256 cellar: :any,                 monterey:       "6b80eff7343ac015c778b79dd5a4fab0e97ca69227701f62241ecb736399ee81"
    sha256 cellar: :any,                 big_sur:        "4c1129397a3e1e72142d669f9a065f12bd851abdc2ad98e935ddde043f44a69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc47fc7ceba2f40fc333d8fe80b6192dce4b6c6102182ce4ac9cadeed4c3ca99"
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