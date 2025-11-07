class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.208.tar.gz"
  sha256 "bce8e14987c6944d728191c18b42a5e46f588f2fb975e166c90823f21b341f87"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9dc02cc97ff576817b57bdf1bf7a4b3ab27a8066d2a4e6fb1cd95449f770423b"
    sha256 cellar: :any,                 arm64_sequoia: "2a256b16e54158a6564556d349ae2734850dd7706b58165918de1a0591424651"
    sha256 cellar: :any,                 arm64_sonoma:  "c5e651044fad6d5acd4629f072f8f865b80a1102322ec6110a9c9371bb93b5ce"
    sha256 cellar: :any,                 sonoma:        "94d1a025541f9fe35b736898ef979250557cbfadce8e1a9c45b0072a2388e779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b351e6130c105ef9fdbe4184c66a5913e552acd85a72e4c6668f7be4316bb427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af3df19ffd1c839c681d35a7a39d270ed2ee1f4680e58b32b34da65840c75fe"
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