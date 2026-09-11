class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.293.tar.gz"
  sha256 "1a1f2fb1e99a416511c3b46207422e5f0104e5e0d9b9309c4be7f457ecf51838"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2bcc1f271a8123d3ecc08b27c01793edb76710d2c6dd9ae01b07e6e7e6e42f0c"
    sha256 cellar: :any, arm64_sequoia: "9fe3cc85bc069b80283cff9e79065c68c6dadbfad9ceefd79ef5c66dcd8b289c"
    sha256 cellar: :any, arm64_sonoma:  "f8a307086dddd97df03b54ddae916011b07eb131d0c7717d8efe21c7c8788641"
    sha256 cellar: :any, arm64_linux:   "91f0939219a9c0e038e15721f4faee44cde60019590170337f56ec0ebd4003e6"
    sha256 cellar: :any, x86_64_linux:  "6db351e1e42c7577e8cce941bea7ee3911668834e032e416e13f8ac14455446d"
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