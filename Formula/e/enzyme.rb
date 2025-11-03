class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.207.tar.gz"
  sha256 "5953d2923fc5e9408f38e8e57cfe408137a50a55d4aef3c88d152434aed29b0c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e39e9ba537f8acbd43167ac96f2aabc705b0ed2de1dab22f6df4444a1636222"
    sha256 cellar: :any,                 arm64_sequoia: "94cc826c7346050bf27c402171d41ec22c0d4d2f6d704fa2fd8754a8aa2181db"
    sha256 cellar: :any,                 arm64_sonoma:  "d77e9a659230f8b1d9bb2577900eda92ec020aafb1c9e98f5da7202939e1a591"
    sha256 cellar: :any,                 sonoma:        "7829844002b4de2ae9f945ebaf777f5d90610122c97fc6560bf1616d90625820"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "499ec346764c062f66ff66fb3199c1b6a39d5c03808dfcb657c86f64c1418451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0f3eacecd881f3e05fc8e93105b1a34cebd101ac1e754235f51a3b0cbdfd1d5"
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