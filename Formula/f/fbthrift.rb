class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghfast.top/https://github.com/facebook/fbthrift/archive/refs/tags/v2025.07.28.00.tar.gz"
  sha256 "c50dfa52865c332081674cf4f9ade640031f24a1fe07ba63eb02e6e9ed3f9bed"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c013bf51509ef2a2067d56b1efb13a38b2c61d1ce73ff3f8b8f9e61b3faca63"
    sha256 cellar: :any,                 arm64_sonoma:  "5593e950c01f4aef7ab1f1cb0d5546ba589a11ecd198d0f26046707b1f3e757a"
    sha256 cellar: :any,                 arm64_ventura: "5144c95693a56fae350b47a1f22dd5315aa7e2ccb2f98c6aaf2eefeaf433bc3a"
    sha256 cellar: :any,                 sonoma:        "81cbeebab655e9d73d9f4df995d4186dc2e02b0c6e04c102106f35698cffebd3"
    sha256 cellar: :any,                 ventura:       "e0ac242ab40fa2dff746e4a35d4fcab05febb23c1330c8f67daec33c4f7231e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fe0f01c5fbed10904e12561c6c72852e52ef519cddb87b9766cdcdd2b463220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e0c4a84ba4997181b2c44def73de6b0693aac9b09fe48df4b2ea04a1f903b2f"
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