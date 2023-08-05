class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.07.31.00.tar.gz"
  sha256 "dd2d288d853d2dfd5b4d93097a751531f0c8dc47b59adb9fd2524e9df6bb334d"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "049f5b90b1808a6d8a50e652672ac52809a2e7b95239923d5fc1da9111420747"
    sha256 cellar: :any,                 arm64_monterey: "6c97b9d0b098b95035c3d6f61502e0c589f4f2b5faad8773ae371becd5d4c4b4"
    sha256 cellar: :any,                 arm64_big_sur:  "f5c74bdd143609d9bfb276ce18d80811c285a3d5e82723f5276253835ba07f92"
    sha256 cellar: :any,                 ventura:        "6b7191a10d857c169bffdf210c937203ea86bd1671454ee4a8e700eb5da78b86"
    sha256 cellar: :any,                 monterey:       "eae732532994193416114ed66ec66d28a304118aa1d2f6185e6f12b6fd197e27"
    sha256 cellar: :any,                 big_sur:        "95cbaa046683116dab94d4bc5a85b6a5a6c67419c1471d4726e0ba97d0892c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cefccefc3fea804a684e6f4376369878b0e63b0b83d90786a0ad0296c1d1bdec"
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