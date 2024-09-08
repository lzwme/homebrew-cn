class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https:github.comfacebookfbthrift"
  url "https:github.comfacebookfbthriftarchiverefstagsv2024.09.02.00.tar.gz"
  sha256 "050576c0544b88b8ffaa03a00085d46c069775251d17b88be81e2a334eb31b69"
  license "Apache-2.0"
  head "https:github.comfacebookfbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b0387ff7d54a0609498e96306c6141ac27b15f61804d0ccd4879283c5b9849dc"
    sha256 cellar: :any,                 arm64_ventura:  "76085393a9f67f67ecdf7785f05763dcfc2dec51fba3f6cf1f9451425d166804"
    sha256 cellar: :any,                 arm64_monterey: "0560d042d32f7db74c7417239a5a288c871a3359edc38556dcd5f422ef3b0222"
    sha256 cellar: :any,                 sonoma:         "9c6ec9c0de522863a44d8501ff3f682a24d072c50fc06f5a54ea5b3ea0f0950a"
    sha256 cellar: :any,                 ventura:        "3608bd8b9ac736b0055427a59d9517de9f3b46b57ff415f99a41c80536e1ec35"
    sha256 cellar: :any,                 monterey:       "b28bf4274f0a0ecdf44c317edeee09a8452723d0958cbea21b70ad73dce8a598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c2ee4a30ec3a0384556a547c3c4804ea8eca666bc84c4fa123a4cf5cd1f858f"
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