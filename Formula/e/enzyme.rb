class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.206.tar.gz"
  sha256 "600fd2db370fb40abb6411e0e80df524aea03f2c1ad50a2765ecaab9e1115c77"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21175bcf378f66e957fbeebf8acfe3f3437b9e55c414e2994fb25c52a89e1c2d"
    sha256 cellar: :any,                 arm64_sequoia: "cc3c897ee8e57bfec1be795272198d87a6ef6d05b2082fc6ff748f2155a3906b"
    sha256 cellar: :any,                 arm64_sonoma:  "f6ffaacb156033d5c3bb5a5c3ebcf9caf829824971dde905c08f6429ade16fce"
    sha256 cellar: :any,                 sonoma:        "c07cde0e370b5deb1ffc4146b94c40ba2536d4a214fcc73e448b121faa037ac4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0458c72edbf1023ba5a22cd9322214a752ca6e9f0aeb58d15a9e989b81c9338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f89e8c85a0105ae77e63f8e9867cc4c3d8c32d47a9559bf1095e2e5a79d9076"
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