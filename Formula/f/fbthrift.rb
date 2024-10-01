class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.09.30.00.tar.gz"
  sha256 "8c97deca2ec886733fabdea293aa7c5178dbe8c8399b7ccbbd188c4eeb096e04"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "39f1ed42199ec5a90b7877f2f59e16f2719c599c324023177fb591d68b872398"
    sha256 cellar: :any,                 arm64_sonoma:  "76dae5c61fc1091ec2383bc3fd756118a7425feacccf7e3f779a19b044a839fb"
    sha256 cellar: :any,                 arm64_ventura: "68757678e81e9bff68bbd0c2e36c58cd15df17020abe8f436b13de4eaa1e2a63"
    sha256 cellar: :any,                 sonoma:        "1835dea5d7eed34b3b0c6050a2feb68da4ab8011d6403386112fbabd00bffea8"
    sha256 cellar: :any,                 ventura:       "c1a0a030a0e81426ca1bbeab42ac7d9518725a0fb7a4d5d7c92585ab35b68d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78be47fa0ac4372487a486050a1189184493167bfb5033c5d3889f3068308e9e"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => [:build, :test]
  depends_on "boost"
  depends_on "double-conversion"
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
    (testpath"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath"gen-cpp2", :exist?
    assert_predicate testpath"gen-cpp2", :directory?

    # TODO: consider adding an actual test
    (testpath"test.cpp").write "int main() { return 0; }\n"

    # Test CMake package to make sure required dependencies without linkage are kept,
    # Link to `FBThrift::transport` as it uses path to `zstd` shared library
    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES CXX)

      list(APPEND CMAKE_MODULE_PATH "#{Formula["fizz"].opt_libexec}cmake")
      find_package(gflags REQUIRED)
      find_package(FBThrift CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test FBThrift::transport)
    EOS
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
  end
end