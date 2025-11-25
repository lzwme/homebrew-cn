class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.221.tar.gz"
  sha256 "00a481641442af63885923d280e47d8ab83b42bec6b301efdf64d6b5fc800267"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5e975d3e40c9be8e8fb7026f5a95ad952eb515600a2ffa995e74b2798866e0d"
    sha256 cellar: :any,                 arm64_sequoia: "340e2bf63e7a9a0f18c0ac50bcffeafe684a3e09dc78f82fbcbe7add1f057ed3"
    sha256 cellar: :any,                 arm64_sonoma:  "c0399bd5bc129722050660caa1f3f1b1197127e417a6427021a98c53ff74db70"
    sha256 cellar: :any,                 sonoma:        "fd32f643359a1e451fd41f323c3bacfd01822e202964a2217d3527a4f2db23aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcaee19358d416d4e5b4e57a7656b4f8a08bc1d027f9749b652f8cfd180b8736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c50086b3ca5bc9d88733e0abeca13b7fd182405dc136b79ccad3eed465ce861"
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