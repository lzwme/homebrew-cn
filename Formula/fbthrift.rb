class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://ghproxy.com/https://github.com/facebook/fbthrift/archive/refs/tags/v2023.06.08.00.tar.gz"
  sha256 "130d6453692ed4f9ceab8ef6b3099bcaaab33f7d244f68674f3f5d1fab31773e"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "91a6d4154cf2b961b4fe13ff3bdafa031cc649674feed0848bd222316274b4bc"
    sha256 cellar: :any,                 arm64_monterey: "ada8925340af2825db5a8ef2234c63f985e4ae4b7e7ac4b05f357f6439e84ca2"
    sha256 cellar: :any,                 arm64_big_sur:  "8a683bb524221edadf2da43d12f25e85fe7d46a2e1adec00178757cde6e539d7"
    sha256 cellar: :any,                 ventura:        "3c62006376b8d3d79bf664f6f6330e173789868f86f2e2df439e56a6f3c7db3d"
    sha256 cellar: :any,                 monterey:       "e716d41153e648ec3c8e6dea1ce2f324ac37ce20600e1fb561ebcf58db805a71"
    sha256 cellar: :any,                 big_sur:        "2966df558cf185363c5983e25bbe37fe7097b9f5381149088f4cd91d85e51947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b1b5fe5642c26864d46db8ca4a48bc6f0a1d69865d22e0b5acd04303176346f"
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