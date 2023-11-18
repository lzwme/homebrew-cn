class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.94.tar.gz", using: :homebrew_curl
  sha256 "8deee5c2ee8246d76b627c6929d3cad18e2c8c03cb79880236bcb6d1a92d376e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1adc69d83b755652ddfa363cde31092acd19bb36eeb1a0dfc28991d3896fc679"
    sha256 cellar: :any,                 arm64_ventura:  "babde41af119de0138d51fae728e878a635b97700377ba6b8caa54564553b7d5"
    sha256 cellar: :any,                 arm64_monterey: "2b26a118634b2eb504cf9412ebad98d1a5d7de1f44492be2abd751032e26ddf4"
    sha256 cellar: :any,                 sonoma:         "f8fe542d9777b332114664acc8c96fa901cbcfc8a3a5495b4789543f08885780"
    sha256 cellar: :any,                 ventura:        "18f95c7903b7832c7d86d5de618ce45e8c79bd51c1716250b7e857c450b4cd19"
    sha256 cellar: :any,                 monterey:       "2cb619ed0dbee30b88ff2bb5a532c5086975cca73d8de22b89d99c1448e8bb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0dd0e98fe820e570108eacafa9c3c5a78aa80632c2a893d8408821d14a82742"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end