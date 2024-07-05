class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.07.01.00.tar.gz"
  sha256 "fa2302fdabf54780213cc3c5b7047226d7d9b91b8e1b9528330f1041c16b25eb"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "13289567de15881fb4c695d1715fa0df9fa728a0f2098aefd529f2850d045361"
    sha256 cellar: :any,                 arm64_ventura:  "25a4d24ab67f22372ee7dbe7dc60d8dc3cadfcb398522467599245a6c4e0e96e"
    sha256 cellar: :any,                 arm64_monterey: "85394b7a79150c04b090840e3344344d8e74c03cfe8bab37c9b124abd91b0453"
    sha256 cellar: :any,                 sonoma:         "5eb9a3f1f24642556b647d75605e84486c4166cfdec5dcb671e8e2e1e02af4ac"
    sha256 cellar: :any,                 ventura:        "d9312c5a4d5642ca0c1af8f4fd6f73132e22d50853308a59ef02ca71156f251f"
    sha256 cellar: :any,                 monterey:       "6fdd562880ccea385a6170eae26c55fc2afa7c25467b36cdd4cbfa08f310d466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf3013eb5eef35c16b26bbf86fcf6c067a8af16ca9a56c349ac8c54c7495d862"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
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
    # to include them, make sure `binthrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "buildshared", *shared_args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    elisp.install "thriftcontribthrift.el"
    (share"vimvimfilessyntax").install "thriftcontribthrift.vim"
  end

  test do
    (testpath"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath"gen-cpp2", :exist?
    assert_predicate testpath"gen-cpp2", :directory?
  end
end