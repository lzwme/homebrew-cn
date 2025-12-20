class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.230.tar.gz"
  sha256 "c734e396e9c819db6745dfa2e85c477c3ec75291fe68f82293d5ddd7460e81ed"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70b49149c75d3b93e18e2b3576e1ac8f9cc1b14d14d402dbcd6c4369d74e122c"
    sha256 cellar: :any,                 arm64_sequoia: "e6bf33c04b88f41a3f8f1569bd0302fe7b7ad83a90feb4100ff60101ecd3bd3b"
    sha256 cellar: :any,                 arm64_sonoma:  "6f136f15cf0f4774fa38f0a498393a509a3b3ad3985838bfd1701bf28d651a38"
    sha256 cellar: :any,                 sonoma:        "2aeba6e1c9c8ca8836df4faf30f92090424ab0a0972c7d4622cf0a4b9714d390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e320f2b72d94d20e2db3402e3e49c69f74713c79e4c513559f003fd6e9462cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a1664c558dc5a8aec27e3bea7142c8ad6c06dcd12a07410a9077545dd765313"
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