class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghfast.top/https://github.com/facebook/fbthrift/archive/refs/tags/v2026.03.02.00.tar.gz"
  sha256 "666184a82c151b373e313de5d9a673de40ff0dc02ed2018f48cd1d68762771b7"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d437a24fa480e1e0e89bf172e9c434e93fcb77361a5a77d589729919e04b678b"
    sha256 cellar: :any,                 arm64_sequoia: "ed7a0d89afd7125b94ce1a266a6c4defd691df73f05b764eda2d53563b9dc930"
    sha256 cellar: :any,                 arm64_sonoma:  "b51c944cdfefdc932f6f727a47527dc4cb52c483332f7897dcc3ab0cc9d06e56"
    sha256 cellar: :any,                 sonoma:        "8ebf32162778438f4115c6602dfb2e4d641a479ae5be4834144ce78884d0d0d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bc97ee4462d8fe026f69b25cf86e5b85e6c9341d7c46952ada3ae7cf5097e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d805f28d18b4ce66a2c1617ed232a8b712ee3601c255b558d58f7fee9ce9015"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => [:build, :test]
  depends_on "mvfst" => [:build, :test]
  depends_on "zstd" => :build
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "xxhash"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "boost"
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1100
    cause "error: 'asm goto' constructs are not supported yet"
  end

  def install
    # Work around build failure with Xcode 16
    # Issue ref: https://github.com/facebook/fbthrift/issues/618
    # Issue ref: https://github.com/facebook/fbthrift/issues/607
    ENV.append "CXXFLAGS", "-fno-assume-unique-vtables" if DevelopmentTools.clang_build_version >= 1600

    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"]
    if OS.mac?
      shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs"
      shared_args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs"
    end

    # We build in-source to avoid an error from thrift/lib/cpp2/test:
    # Output path .../build/shared/thrift/lib/cpp2/test/../../../conformance/if is unusable or not a directory
    system "cmake", "-S", ".", "-B", ".", *shared_args, *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"

    # Save a copy of FindxxHash.cmake to test with as it is used in FBThriftConfig.cmake
    (libexec/"cmake").install "build/fbcode_builder/CMake/FindXxhash.cmake"
  end

  test do
    (testpath/"example.thrift").write <<~THRIFT
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    THRIFT

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_path_exists testpath/"gen-cpp2"
    assert_predicate testpath/"gen-cpp2", :directory?

    # TODO: consider adding an actual test
    (testpath/"test.cpp").write "int main() { return 0; }\n"

    # Test CMake package to make sure required dependencies without linkage are kept,
    # Link to `FBThrift::transport` as it uses path to `zstd` shared library
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)

      list(APPEND CMAKE_MODULE_PATH "#{Formula["fizz"].opt_libexec}/cmake")
      list(APPEND CMAKE_MODULE_PATH "#{opt_libexec}/cmake")
      find_package(gflags REQUIRED)
      find_package(FBThrift CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test FBThrift::transport)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end