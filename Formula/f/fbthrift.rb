class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.04.22.00.tar.gz"
  sha256 "600e37bb744edd97bc7bb20de60041041e365811194fe87a6926be7380919c1f"
  license "Apache-2.0"
  revision 1
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c1dcc47c88b085bc91f7f256cfaddf70338c702f7f0141753d24beeb8b08346"
    sha256 cellar: :any,                 arm64_ventura:  "f737e438db8dc49486bdcfb04ea97f2706786aacfdcbb68b0c5f4a254b7e5020"
    sha256 cellar: :any,                 arm64_monterey: "d1a9a5bb8b7077122c79e11a753393306a6e8013a05b9c054a8510eb0a4b9824"
    sha256 cellar: :any,                 sonoma:         "930bd901bb3680eafbc71e101fe3f60410ec15c8c9c3537735ecc04bad925742"
    sha256 cellar: :any,                 ventura:        "8ced2c1d40bdae87367e938174062449e05ec92fcb88423a30b4cbc4c46d682e"
    sha256 cellar: :any,                 monterey:       "d1e7fa6ab1424c173f548882a57db7a380fa73b234248141490143fe24bb8f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "015c5575363cf0278643c583ac9ad6b19ec7fa9f953578284aa95a8709589fd9"
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