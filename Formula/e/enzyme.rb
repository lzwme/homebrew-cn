class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.262.tar.gz"
  sha256 "5b7dfaa68ef519df63e57580a64fb48e1db12e3d91bf18e728ed0766dbcde3ac"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57673cd7d2577d8aee74b6f285c75bfba4224389ddefc5c568589a39e9aeda17"
    sha256 cellar: :any,                 arm64_sequoia: "1ef812269b400e3365cb430f9b1a8d1efc12274d10339bb52c19fbd6f2b9b2e8"
    sha256 cellar: :any,                 arm64_sonoma:  "6c0dfd62206caef2c9557c8768e413aefb69cc9e59c14b5d0caa4d7c6d13a30d"
    sha256 cellar: :any,                 sonoma:        "546428dc48e7c2f21500e86a3d000901fe91aef18ca0bd7f7cc2c30e739d4025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d682d2a1d63d35a5af4047a4d903313a48d6d0f91957279cc4d7568b151df31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74a5b4a8fbfd4f4d0a5b9074f1852025072db3a127f7ff111075016d28dd4b9"
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end