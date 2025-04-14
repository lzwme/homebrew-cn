class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2025.04.07.00.tar.gz"
  sha256 "c186db1b797be72d5d84265a15378012329427ab5324b5af127d1f641b2ba700"
  license "Apache-2.0"
  revision 1
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a4a16782715013cf5e0f4b15681ed1d48562966b2d8178ed5ff684d16b3287c"
    sha256 cellar: :any,                 arm64_sonoma:  "2a9139c2892c7b8e4f95edef80c07da08bb2dcc7823c01c550d59bf4909e78c9"
    sha256 cellar: :any,                 arm64_ventura: "175bc0a29cdb8a1bc27e4581b4bcc31080f18ca211225b14308454609d1a1c5b"
    sha256 cellar: :any,                 sonoma:        "ec2029d527986d11dac3784e8cc28ae8d66942b8fa812250ba7276b5ce5f4c7e"
    sha256 cellar: :any,                 ventura:       "65a462f1f00a83432de5b0a876f5674258fe687d58729ac1e8fea1bb39f7b2be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b774e06c598ef3fa04f4a77c30a11a1360a10ecb3858b845f0d9fa00c3c417b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f8340035739afc14cdec39e44aee63845e1e0372a33135e4c65041b30cd1afd"
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
    cause "error: 'asm goto' constructs are not supported yet"
  end

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
    if OS.mac?
      shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs"
      shared_args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs"
    end

    # We build in-source to avoid an error from thriftlibcpp2test:
    # Output path ...buildsharedthriftlibcpp2test......conformanceif is unusable or not a directory
    system "cmake", "-S", ".", "-B", ".", *shared_args, *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    elisp.install "thriftcontribthrift.el"
    (share"vimvimfilessyntax").install "thriftcontribthrift.vim"

    # Save a copy of FindxxHash.cmake to test with as it is used in FBThriftConfig.cmake
    (libexec"cmake").install "buildfbcode_builderCMakeFindXxhash.cmake"
  end

  test do
    (testpath"example.thrift").write <<~THRIFT
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    THRIFT

    system bin"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_path_exists testpath"gen-cpp2"
    assert_predicate testpath"gen-cpp2", :directory?

    # TODO: consider adding an actual test
    (testpath"test.cpp").write "int main() { return 0; }\n"

    # Test CMake package to make sure required dependencies without linkage are kept,
    # Link to `FBThrift::transport` as it uses path to `zstd` shared library
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES CXX)

      list(APPEND CMAKE_MODULE_PATH "#{Formula["fizz"].opt_libexec}cmake")
      list(APPEND CMAKE_MODULE_PATH "#{opt_libexec}cmake")
      find_package(gflags REQUIRED)
      find_package(FBThrift CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test FBThrift::transport)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end