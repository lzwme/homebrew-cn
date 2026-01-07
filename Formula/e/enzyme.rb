class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.235.tar.gz"
  sha256 "c459d5c388549166b6d4f07c33998f64773b6ba930dfe6113c88696df96e2285"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9fce23cc7cf247a52e2a6b60a3202183c06292af035ef7519bf5caa0c2f7b02d"
    sha256 cellar: :any,                 arm64_sequoia: "4d79689c034f2a2d9cdcac5609dc2c34a6d9370f49342f3601689c84708c0926"
    sha256 cellar: :any,                 arm64_sonoma:  "b3b37cdd95ec7cde18a1c4095d4d2a698c63413df16c4fb6a5c339d06aad6f81"
    sha256 cellar: :any,                 sonoma:        "10869f9eb534b430e023749d5c445094e933ee2d399bbb65729b22a953faffb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc4d5dc8ba8e29e6dc9d46ea7f530df939a543ed6918ba95ed5ccea7246e40d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c492eeef3435f34f2532ad1eecb41097edad69e22e43f9a3a491511c12614b8"
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