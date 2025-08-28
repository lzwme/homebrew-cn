class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.194.tar.gz"
  sha256 "ee9cadfadac050b49764970aab8443aaf2f44231a60c20bae72f835161e66a7a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89edb238e86b5440deef49bd5e70f665b1a73ed869980e969994988de1e5f4be"
    sha256 cellar: :any,                 arm64_sonoma:  "411f6f7580ead8e7ea6c04b37a18d5841c5d01ef8d157d17cbd8e60f92f1f16a"
    sha256 cellar: :any,                 arm64_ventura: "0aeba6bf8a08bbe87d58200d42bf4d6b79524531d308c65bf89e9309b2e16c06"
    sha256 cellar: :any,                 sonoma:        "0fc3a6f222d39d5d960735eb3468e1e74640263891f987a56d0e28f7235c3883"
    sha256 cellar: :any,                 ventura:       "5bd5bb26360cc7c718c8358af8e3ac16b18785795a491d8dbac6b47d140be118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "673366de9d3e5cc57027011bdf5d9fc9baeb8dbfc83907449aa530b45ed83b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da10062474181d9b2f3b7b89ba480fcf6938f84ab1cfe64167347f0812caf1bd"
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