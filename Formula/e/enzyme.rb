class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.195.tar.gz"
  sha256 "6aa6c12caab236ef4c60680c87a71afeb805f7d54e4228b1025b8e26c53594ce"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2b24cec87a75951df03ad6d4d4b83f4ea9b7a0a45fed5468c67c81b6d6588e20"
    sha256 cellar: :any,                 arm64_sonoma:  "4e3ae386160e06e6d8b0bd73556bde1679f64a4c9fcc19f1b802608e5076e42a"
    sha256 cellar: :any,                 arm64_ventura: "51c4acc222da5c0c0abfa525c459bc45dbddfb7c767f1fee067b86fac43e7b76"
    sha256 cellar: :any,                 sonoma:        "bf59eb360eb2da564808c837d3e62b8a609ea80413e616ff85b09a67c894067a"
    sha256 cellar: :any,                 ventura:       "cd0612b17f76d7c33d00e68a5ddda87f1cef8fb390d68ddaf23f1729fbb91228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35640a083c86f54b0e24ab9255bb0a4d001f3383c0a6a55781c2c5961311dee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbead83b432bb688091623984bae446ad3596a40c10f549a0bfc23f2e7cb7b5"
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