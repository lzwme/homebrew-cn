class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.06.17.00.tar.gz"
  sha256 "bfacfe477c1152df43a1681c31801f337ef7f67bc85507e09340abdd146cca7f"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "49f8317c823f5f43ef6fdca633b310d8637b56d171321cc7186d4521a1652337"
    sha256 cellar: :any,                 arm64_ventura:  "b768cb9d44bc52149c41891615119b756c3b3831528871000c74a5d15dc017b6"
    sha256 cellar: :any,                 arm64_monterey: "9daa9bd53f64a7b0c0758941a669e74bf3071311c6c28f66c59c42a2ec1a7187"
    sha256 cellar: :any,                 sonoma:         "969d10646bfc246d4f942f638ae573d0097099e066da40ca3e79554bf0efa38a"
    sha256 cellar: :any,                 ventura:        "99d7e1fee4feabd10503a874e712b14c8805e89c079e6cf4eec7dea99b6c9058"
    sha256 cellar: :any,                 monterey:       "f5faa1ecdbbae32a887995f47169681378cccbf0a7036d6d603ebe62a76e7219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf9e557952f0ce6bcea7962c6d023269c74258201c311c8266b90ef83dadc79a"
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