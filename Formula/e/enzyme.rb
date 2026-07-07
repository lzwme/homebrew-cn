class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.279.tar.gz"
  sha256 "dfaeca55b46acd1d800b8680d554c63f03b7ec2e2a0cef3948740d7d03b1ed99"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a825ba58eeb57ec27050ab2e539b20ff4d9a365214b9c178d65f6d79e87af255"
    sha256 cellar: :any, arm64_sequoia: "b9b52d780dd8357b87c4d50ad65b844305c41103160de6554602f51bdabfbe7c"
    sha256 cellar: :any, arm64_sonoma:  "64fdd10ab9bbfc2bb03a8c03861ffd7e86f004af1949593626428399b7f5e67b"
    sha256 cellar: :any, sonoma:        "110dfd2aed20bfc26af244d4c70f999785b3142bb6696db7c53bda005c141528"
    sha256 cellar: :any, arm64_linux:   "b4b07104927c42447adc28102a1feca8e620c35460166725bc8a444e2417a5c5"
    sha256 cellar: :any, x86_64_linux:  "f8598262e12d2eef3b6d89610491a1857ccb29e9dddc38ebfc47c779533d2056"
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