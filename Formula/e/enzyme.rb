class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.285.tar.gz"
  sha256 "e759ddd9e8129d5089358626bfdc412d51a664624f3d151c24b63d54cffae2de"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "41bb9c614e637e10d3ad91ae14a23f4e7017d29e213a0fd8c798aa28d961011a"
    sha256 cellar: :any, arm64_sequoia: "3eab65a45bbc67e4cee00d8f442c7c8318a5fe80358fe14754f42ae51bdde9eb"
    sha256 cellar: :any, arm64_sonoma:  "427bf3c19339eafae7e9b8e1a2214b8f9c748817c23d29485542871236760916"
    sha256 cellar: :any, sonoma:        "17b8ccd767f369e9c9be2e888869ffc52966d2a0fa2f589ca816789ceaa2e22a"
    sha256 cellar: :any, arm64_linux:   "71d343f9983cd63bd717e00a9efac5395a10642201cb9c17e5e95a7f7f884f8c"
    sha256 cellar: :any, x86_64_linux:  "a0dfaca0c89d17e2ebc81165cbd797a26b9256b6de0f473138d0440888218b3f"
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