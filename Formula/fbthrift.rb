class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.07.17.00.tar.gz"
  sha256 "4c02e0eb377428e3069e7fbad8d0cd808f43e9f52fea7c2e6b5cce2730708eb9"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bfb28c8fbf0511b084527002e37f7000520aeca36dd174158a943ce68228e986"
    sha256 cellar: :any,                 arm64_monterey: "0add6452a72c74b106639c0cd5c56c325815aefa19986e368ea1d34a7a726c11"
    sha256 cellar: :any,                 arm64_big_sur:  "e6c327786820ec99a98158029911341801cb35efe4f17cd89dadeaa2f4d3af9a"
    sha256 cellar: :any,                 ventura:        "7bf2955894cff3e448e4e928b3d7daefaa2cb642a88b9004eba517b17ff00aef"
    sha256 cellar: :any,                 monterey:       "8c6c65db72b41506dc85d1bbb886b1c7a2dc4582517bdd4a1c7f65508824ef37"
    sha256 cellar: :any,                 big_sur:        "3fe045634a39e3c678a3d460a3e8687a58e39a482fc82dcdd11865dab36b1705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1ffe0105c2f92e702963f2c57ebe9640c93a90a116941ff42ea89518625827d"
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