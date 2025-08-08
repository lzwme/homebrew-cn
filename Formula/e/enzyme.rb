class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.188.tar.gz"
  sha256 "54d3598b9394fd76d30b3e862e0de6801efb21da3ae2d5144f8fcad019bd1c52"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "9ee7a2f6783f3a68e79211209717005ce0c4912933b580702dfbb3582196ea20"
    sha256 cellar: :any,                 arm64_sonoma:  "421196f2ebbb1d9b0cc47d3854b958514549daeeb9e4caac54caace4b441583a"
    sha256 cellar: :any,                 arm64_ventura: "369a2b537ead5d880935f9c5e25c50e83a78548f4b7623c166636c1e6bb5fa71"
    sha256 cellar: :any,                 sonoma:        "877c8022164246e853bf5dce8721064da8bee95dcbb8f31b58ce926125a3131d"
    sha256 cellar: :any,                 ventura:       "fc4a46192e4c18ad4d57dea860c51f278c51e9624033e3420e00b2f3b59ceb2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30b3aa6a4ac527da68f34c45276575f2f9e78e2ad1e703265b1099de6e08fc63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c8a0cadb8c315211a1fe9740758c67dce824ea5610a46beeff0fb64ed3c6d0d"
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