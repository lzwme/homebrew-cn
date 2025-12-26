class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.232.tar.gz"
  sha256 "bdb28f9cf6f6bdfd8458e225d32040713f92e25371a417b8086b449697433ecc"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a50e466b0620abfc2d8a6ce0851c99ab4d3329959bc7249e651867a070858c3f"
    sha256 cellar: :any,                 arm64_sequoia: "d18c2efc573ce72d6e56a6790934eebb629a8d6fbb6d9e0d3b862ae1ad9829a2"
    sha256 cellar: :any,                 arm64_sonoma:  "dd1903086c8526c732da5d602efa515f341e79f8363ef944b1b6659c3ecd0d81"
    sha256 cellar: :any,                 sonoma:        "a9ee7461d5fa8730d62bb1b5e392c455c46a5611098190a6d86b58973c6636d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb64dec42e9d9ae247f76adf969eb80f507c0fdc1a761ab0c60910428c42e5fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b0cf6270555c2e0d651cb10c6c1cd6817e2c5cc04610278de5a9c44408201f"
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