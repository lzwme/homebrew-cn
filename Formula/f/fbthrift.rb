class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghfast.top/https://github.com/facebook/fbthrift/archive/refs/tags/v2025.09.08.00.tar.gz"
  sha256 "43e7b58913c5e633fd5f33d9bb6c6f8e6d94496112064a7b50ba1632dd497c8d"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27f77a4b3d119f4f6c03e4d19aefe4153883b5757d48ce9d4d6c395f7e19613a"
    sha256 cellar: :any,                 arm64_sonoma:  "6bbbcbe59efd849d2b198df2289240fb20e74ba88e51bbfd45a210b9185db016"
    sha256 cellar: :any,                 arm64_ventura: "29a2c1da345bc683535089d5cdfbc98616257cd4da98c62e7767dd691676d384"
    sha256 cellar: :any,                 sonoma:        "285cb451059847489fc768fd824dd1df46105d80104fda5e000815e8ec9ff84e"
    sha256 cellar: :any,                 ventura:       "3617956ee8352cccd187c5b5b3bd506229b2305436529bdab662ce7a22b6298f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e97f46bcd2530fe8a1918419a46833edc24b4948c1668dd41c95d349c4752426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89fdc25b506518fd8de7af0ebe3c787d8ebc49b734a634659efa1bb010fc1a11"
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
    # Issue ref: https://github.com/facebook/fbthrift/issues/618
    # Issue ref: https://github.com/facebook/fbthrift/issues/607
    ENV.append "CXXFLAGS", "-fno-assume-unique-vtables" if DevelopmentTools.clang_build_version >= 1600

    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)
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
      cmake_minimum_required(VERSION 3.5)
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