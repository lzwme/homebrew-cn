class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.205.tar.gz"
  sha256 "b6f981cefd0456d24bd84f79d927fc2a26f7e33cd3abf5348eb6ad03ea959e3d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7030b734b32e4458296dce008e24ecd4482776bdb732fcce905d0dfe22316d4"
    sha256 cellar: :any,                 arm64_sequoia: "7b92cb85b4702a9072b1dac6b69986060b875cfe0e214741c80a56b6c02cfc91"
    sha256 cellar: :any,                 arm64_sonoma:  "b9aca81b980a4b3f2b817bd579995adf5a78d157d4672dd223ef8c3c61d0411c"
    sha256 cellar: :any,                 sonoma:        "27afbf9203a3a9c21ce5c2af3b743d56cb55686b2ac68e6524088132a32fee3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bc2ce8667c583351ae38a9c87d10f61829bad6c884d0e80d1348384e8a0450d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfe940c3cd21e249b05ce3b7a4abef59ad92637e5af820fd987ce6654b0457d7"
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