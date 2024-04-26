class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.04.22.00.tar.gz"
  sha256 "600e37bb744edd97bc7bb20de60041041e365811194fe87a6926be7380919c1f"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d2bbbb6f0e906c3813bd343359dc5028979be62e5d6724475254b44b92422f2b"
    sha256 cellar: :any,                 arm64_ventura:  "f5dc1e40a3974fd1dfc5f03e59aa0b99505fa18a048f077e3d6e2755897e71e4"
    sha256 cellar: :any,                 arm64_monterey: "3313dbb48544f38f67a52a7bd09771da2a2a826d4d98e0fe6b6d3e18fd2e9147"
    sha256 cellar: :any,                 sonoma:         "bdb89d956fca12daca2d5028dd2a87f3cc2e67c8156fb2523aae88a600a18ea6"
    sha256 cellar: :any,                 ventura:        "4cbffd3a903688ff4210213467cb1007790e339e40898462b1e8668efd154bb3"
    sha256 cellar: :any,                 monterey:       "6f1fadbe7aa318eca8b67f61a0d273a36dd69d317154e3f6456d41f1ffd17b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "365b8bc29d9a3223d8af32e58a32c3c8f9f4a8b8072f7e6f253236b8f7fab026"
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