class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.302.tar.gz"
  sha256 "75869494b592b46c7dffd4aec57ced4634aa8d8c65ac8c89eae65b30758c6b94"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a0c4ac0b5bfa9be7c0dd4c6f23ea3b889d234184afa876bc2f64a18c6e637d5"
    sha256 cellar: :any, arm64_tahoe:       "a22bf48e519f06a7edb581b48d260fcc978a0ae73569fc4e003b87a0c394ca16"
    sha256 cellar: :any, arm64_sequoia:     "ef942aa618bf3c0b66551ccb6a330d9e450cbb155ce673e44b5f9b0ab43f491e"
    sha256 cellar: :any, arm64_linux:       "b8b8c2bae0f7b9795a43dc8754acf61d3baa0a8a5167750cc654062a184e3bdb"
    sha256 cellar: :any, x86_64_linux:      "249370903c02696af0439fb4079505dbd8b494531ccb26227ab5b39c798d1096"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  deny_network_access!

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