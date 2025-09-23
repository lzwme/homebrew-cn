class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.200.tar.gz"
  sha256 "12e74d8f0452f8984841033df2fafd504ab26eb99888b25440df9d9525ec9063"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e53fbb798d64537b90816d85e743aa07bea6635d5fc923018229eb5b73fd77e6"
    sha256 cellar: :any,                 arm64_sequoia: "4c1a5025b4922fbad25db7599afb72c78cc1f52d62f2544b56284a3afbe1a72d"
    sha256 cellar: :any,                 arm64_sonoma:  "e6296be58a9ebb6c46cbb63cebfdccebfdc6210ea40d6a414a5a3d5fac79be65"
    sha256 cellar: :any,                 sonoma:        "5a0955bf8e52ff13eed7c1a45006b48621fefbb76d533896f07628241776a65a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b38620e2bfd9e99d446db974fe872c133374b3647776c56619cb808aea99be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067dc749f332ef4f238b5d07b6f5a77e5d6843ab9e25eb60de67dfac0e4ccc55"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end