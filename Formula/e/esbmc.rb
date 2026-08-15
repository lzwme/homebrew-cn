class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker for C, C++, and Python"
  homepage "https://esbmc.github.io/"
  url "https://ghfast.top/https://github.com/esbmc/esbmc/archive/refs/tags/v8.4.tar.gz"
  sha256 "9959fef848ffae597adac6fa2d74063f9553b4fcee93ed7cbe8aae3bd667bf91"
  license "Apache-2.0"
  revision 1
  head "https://github.com/esbmc/esbmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7a2dd8d049c31c77526dc74c60ddbb7539f6e2aae5a09c4c79b837e8e58a43fc"
    sha256 cellar: :any, arm64_sequoia: "b036405d684357a6d5a833fad6f8a745f9098f64f3afcaa47569240dfc54259e"
    sha256 cellar: :any, arm64_sonoma:  "d05e6c03f10e9f4c6aed731fdc0c2192e185279d4d3bebcd5b487b5d7e6ff7e3"
    sha256 cellar: :any, sonoma:        "dabc7f67e67e32f1d8ba4e659b98940fcf18250e1615fc1523f68d8f177b2044"
    sha256 cellar: :any, arm64_linux:   "24c6357feaf8fdf11f9355bdce4c462d561a8c6df56389e4d83648f914cd40a6"
    sha256 cellar: :any, x86_64_linux:  "e89aff2ca3fdc81baed9af7ee2dc6ca206b3042c530f8a5a63b7699eee93a6b5"
  end

  depends_on "bison" => :build # macOS ships 2.3; esbmc requires >= 2.6.1
  depends_on "cmake" => :build
  depends_on "immer" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "bitwuzla"
  depends_on "boost"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "llvm"
  depends_on "python@3.14"
  depends_on "yaml-cpp"
  depends_on "z3"

  uses_from_macos "flex" => :build

  def install
    python3 = which("python3.14")

    args = %W[
      -DLLVM_DIR=#{formula_opt_lib("llvm")}/cmake/llvm
      -DClang_DIR=#{formula_opt_lib("llvm")}/cmake/clang
      -DPython3_EXECUTABLE=#{python3}
      -DBitwuzla_DIR=#{formula_opt_prefix("bitwuzla")}
      -DENABLE_PYTHON_FRONTEND=ON
      -DENABLE_FUZZER=OFF
      -DENABLE_Z3=ON
      -DZ3_DIR=#{formula_opt_lib("z3")}/cmake/z3
      -DENABLE_BOOLECTOR=OFF
      -DENABLE_BITWUZLA=ON
      -DENABLE_GOTO_CONTRACTOR=OFF
      -DBUILD_STATIC=OFF
    ]
    args << "-DC2GOTO_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    args << "-DENABLE_BUNDLE_LIBC_32BIT=OFF" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      int main() {
        int x = 5;
        assert(x == 5);
        return 0;
      }
    C
    output = shell_output("#{bin}/esbmc #{testpath}/test.c --no-bounds-check --no-pointer-check 2>&1")
    assert_match "VERIFICATION SUCCESSFUL", output

    (testpath/"test.py").write <<~PYTHON
      value = 5
      assert value != 5
    PYTHON
    output = shell_output("#{bin}/esbmc #{testpath}/test.py 2>&1", 1)
    assert_match "VERIFICATION FAILED", output
  end
end