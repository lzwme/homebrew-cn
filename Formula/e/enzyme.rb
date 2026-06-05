class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.264.tar.gz"
  sha256 "4c4a3148777d6b72e96693cb91d248fccdc25e323875e02cf58b2e598b1754a1"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "343fa4409423c11a498a1479d446b4e2267ac5b7232a3d86887496684b68c7c2"
    sha256 cellar: :any, arm64_sequoia: "2b01653159d6b906cdff7dea41479408dcf4ad0af98cee24fc8e298e8ffcf9b7"
    sha256 cellar: :any, arm64_sonoma:  "fffe700fd83e3850aeec4fae4c203c8f0293b102f2b66bb357235ade1c6998ce"
    sha256 cellar: :any, sonoma:        "390bebd17bc969015442df80058c40bc18952e35b3f9720bc7333d2355e169d1"
    sha256 cellar: :any, arm64_linux:   "fd81892c464e12437c3d626672a8d46cbdfaae2d1612cb9bdc56a63a217e5fc5"
    sha256 cellar: :any, x86_64_linux:  "cbbdd84d9c1f91b0d6df7103d2b48404f7e9b5d4b2123931860da95765dfbb19"
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