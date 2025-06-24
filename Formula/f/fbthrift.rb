class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2025.06.23.00.tar.gz"
  sha256 "dc177d830d5cf13980856c844b135772d78f9e9dd93c82b1fa927e045f46c4d8"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cfffdeaafcd247d88e1dee19fdf385c6818e922152dc9631bd4ba3d101851fa9"
    sha256 cellar: :any,                 arm64_sonoma:  "b295aefb819e9ecd6d3055fff8ad3b6851cd9c62763470a8e5b87bc1ffc099f5"
    sha256 cellar: :any,                 arm64_ventura: "0268d0fad0321d46d52bec495827c6a218dbde44a42674bfa3a99aed54e0d653"
    sha256 cellar: :any,                 sonoma:        "8db6864e94f026d12d169bcf05af4ee437e1a7aa800cbbb218a29ed8da82e3db"
    sha256 cellar: :any,                 ventura:       "4aed270c064d8785a4d49e52c85f28dd33c00aa5df26b6874a0da10e5b5ba574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "783e55f70956a3e30e3122a06456227ac870a3158aec07d36574c0b30400fbe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02fae836d531bc8d7f6ed59a8fa40c8b5d2c022e1d464d8da2b6767959c7456b"
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