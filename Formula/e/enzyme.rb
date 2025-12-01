class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.224.tar.gz"
  sha256 "602f0112a13d4fe71c318fc8388070492706f036e32f0d6e81f46f82167e8c4f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b44c2008dca580871ab0fecb31520225d5b3814f95e18b96483d17858fd800d"
    sha256 cellar: :any,                 arm64_sequoia: "494ac4ec9f3e20e9868792a337af361bd02ff2f85fc2d21d96fb839e3f04d09b"
    sha256 cellar: :any,                 arm64_sonoma:  "176dbae6258ae14ddf84eaf9f57e5657a2b7f351006098e03f3f15b22808923e"
    sha256 cellar: :any,                 sonoma:        "7e3c4033c7e490cf397c18f37ab717c7f23a154b6390af8c366f75c83c7b938b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b06900b84be97734383ff3306ffc85aa4bd8e125aa464c7fa2b347d22a5da1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7c16b77c902f6ac8aea3f05f7438bca9a867cfc3237ae43cfcf0272d327a523"
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