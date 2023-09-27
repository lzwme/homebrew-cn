class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.09.25.00.tar.gz"
  sha256 "f129961b60501be7eb3bff314b1af42472cf0fa8aede15d55977825035bde1d4"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7ace26efa6fec88c5799546694ef7941185b848ecfe77b004891afc51425a7f"
    sha256 cellar: :any,                 arm64_ventura:  "bebe4f7bb5d02ebe993c54118da2d09cfaa3ea5722b12f16a2c4dc78f26c6c35"
    sha256 cellar: :any,                 arm64_monterey: "20fec2114c682981a8211f6c113e309c11d2785d246d12be827bddbd25097fd9"
    sha256 cellar: :any,                 sonoma:         "ce4e459854bcf325757c2fd6387944a12670efb1e8ceea8e7319820997914b0d"
    sha256 cellar: :any,                 ventura:        "964497f9d16f5e4b5a910b86b3aee1ffd111360d416a82ee4e790708f40fe7f8"
    sha256 cellar: :any,                 monterey:       "a33318c2902ff2a92328b9aee073acbf72abe1024dd6129eecc75448230f333d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab96bf1690688d6d868d58ee6da90af798837e5d9ac8d4b4b04438b0f7097d4"
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