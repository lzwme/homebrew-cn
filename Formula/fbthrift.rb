class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/v2023.03.06.00.tar.gz"
  sha256 "185019e8205eb3d143b084fcd0a6c65474de30c1ce5da1a6e145cc11f7655ffc"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e57b9e5df4f92ebf73818d2cdbe7d4c5e15bb2aac40fdab1f218f963c1a30ae"
    sha256 cellar: :any,                 arm64_monterey: "62420892947306b2f5c9ddae2e03439104128a85584d40dac2ff54a750d8d5cf"
    sha256 cellar: :any,                 arm64_big_sur:  "6f0afc50916a48f951bbe81b04d454618d63a52df707533176db9353a8619013"
    sha256 cellar: :any,                 ventura:        "9b8fa09cd1c9d5de2e69aa876d394da8404ae7cd526ed7584043e4a52c658f10"
    sha256 cellar: :any,                 monterey:       "28401cb2f1c419d4258e780a5c5c83776e9c888b11d2e614562248a746fb78cd"
    sha256 cellar: :any,                 big_sur:        "9143a7ce952b6d464ab8ba61cdf29a943c8730add14b46a2c14d145c7769fc16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "771ed4720009ae0bdc3c3a63b5da47ac3cdd6e3ea0607066edb86d9767e7d39a"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
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

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, *shared_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"
  end

  test do
    (testpath/"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath/"gen-cpp2", :exist?
    assert_predicate testpath/"gen-cpp2", :directory?
  end
end