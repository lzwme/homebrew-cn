class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.05.01.00.tar.gz"
  sha256 "7d6b9272c637a44767cb30e75d6f703fdfd6966bababa61fca773e68d299bfe0"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f3cb9196e2030e47988c98be7e6057d475012cfaacfa5d989c6d6d1e8123b796"
    sha256 cellar: :any,                 arm64_monterey: "c6e797ab6a8a2b9dfd2c874e052f6c811a1fdac838b29047066e251b0e625df7"
    sha256 cellar: :any,                 arm64_big_sur:  "0fd6a851bcd6ad3dfe7d8a0c9ca95f5300b18225d2ec918d5b783049d93c9f2c"
    sha256 cellar: :any,                 ventura:        "ec873f01128ab96f24705c5acf54c78a657469b6c0a13519b63d2a872141d70f"
    sha256 cellar: :any,                 monterey:       "b93002e8227360e51e328431150effcbd79a4909086462c5d3cd5fefe4cfda59"
    sha256 cellar: :any,                 big_sur:        "d2b9b5a6e11db32c6505eab8e6e4c54ab93aaa9f7348392950ebdf469bce16bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "992c572cac30641061796294209aa208f98bcabe42759b44edb9ba5c1bffac36"
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