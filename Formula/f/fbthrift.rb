class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.10.28.00.tar.gz"
  sha256 "3180aacf5dcc715bae9ed1cc107ed589fa2934795ed9ba69585fa3eb97b5b57a"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "06cd3110c6dec108df5cd091ed1f3860e2c35ea4c46a7a5ee3962b56bf32d405"
    sha256 cellar: :any,                 arm64_sonoma:  "2b16e7c2d20c46afc464255563168d312c9ba540b21eb57a7270bfd44fc96dc7"
    sha256 cellar: :any,                 arm64_ventura: "84e934e0e96d1755f7bc41893f6f01f65093c5c2dcabbeb086da208f8f23d13f"
    sha256 cellar: :any,                 sonoma:        "20affe8d79807ebdcc952fb4fd65912d4a2a3e5f4c74db6f21ce87f00fed4026"
    sha256 cellar: :any,                 ventura:       "5b8eb65560355b6790ebbb0f1856ce3b6963761b5b64e18ab55cc7b9101e7e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7e3f8a647ac68d2c633dd7f4a31d58d7aad48eff3d12ce1e7dacb55203c95f"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => [:build, :test]
  depends_on "mvfst" => [:build, :test]
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "boost"
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17

  def install
    # Work around build failure with Xcode 16
    # Issue ref: https:github.comfacebookfbthriftissues618
    # Issue ref: https:github.comfacebookfbthriftissues607
    ENV.append "CXXFLAGS", "-fno-assume-unique-vtables" if DevelopmentTools.clang_build_version >= 1600

    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `binthrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "buildshared", *shared_args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    elisp.install "thriftcontribthrift.el"
    (share"vimvimfilessyntax").install "thriftcontribthrift.vim"
  end

  test do
    (testpath"example.thrift").write <<~THRIFT
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    THRIFT

    system bin"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath"gen-cpp2", :exist?
    assert_predicate testpath"gen-cpp2", :directory?

    # TODO: consider adding an actual test
    (testpath"test.cpp").write "int main() { return 0; }\n"

    # Test CMake package to make sure required dependencies without linkage are kept,
    # Link to `FBThrift::transport` as it uses path to `zstd` shared library
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES CXX)

      list(APPEND CMAKE_MODULE_PATH "#{Formula["fizz"].opt_libexec}cmake")
      find_package(gflags REQUIRED)
      find_package(FBThrift CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test FBThrift::transport)
    CMAKE
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
  end
end