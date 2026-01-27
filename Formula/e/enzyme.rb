class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.241.tar.gz"
  sha256 "1e5104e950c8cb141a18deb2a2011e133f659e95ef6c221ce89b054aa68343bb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cd92d5ed6a6d5f781c71a691b56a812d664555a93b21f119ea25b41d2a24f4ae"
    sha256 cellar: :any,                 arm64_sequoia: "fecea387bf7c9210b8767ee00181104a7822f6ffdf51affe5be6c168e38f78ef"
    sha256 cellar: :any,                 arm64_sonoma:  "50da0a28336a8d550281480545b1683545032051594880ba0f816c34088f3540"
    sha256 cellar: :any,                 sonoma:        "81b021c2e08cd27ac52fd0784d035c45147cce2f8b1492e4aaeb23a95d507aab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e198cb2d3414d64bc899e77a24e9e216aeac93d3647c189223dbec6ebb23438c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4cc63c81d50e1c8b7bdef32b814afad9bc5dd263856b937b8558b17de645b9a"
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