class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.281.tar.gz"
  sha256 "ab7f48d8d640734b512c35d7a9608d4c614305ba3f8ecc97eb057f31caf7a145"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9ac46323d412ef63f174e13a660463a8425cf327f0d56289fe37d670983c814"
    sha256 cellar: :any, arm64_sequoia: "943d8a57a8514ae5073b42678abcf78ea7f6261f01ff23435edf6c71106d5459"
    sha256 cellar: :any, arm64_sonoma:  "771c2e6fe367681683731e13398bd001f7ceeebc6a6330cf87ea0dbf493bc2d6"
    sha256 cellar: :any, sonoma:        "72e1ca52f0209e83ce41f5f3b5485b1120fb41623f4ae49e9e0a1b9f3f45f1b4"
    sha256 cellar: :any, arm64_linux:   "a89803546b3042b8a1bb593fb5547751545f0555efd63e65e76c0f1b0c277782"
    sha256 cellar: :any, x86_64_linux:  "ef0729435a9fcd56b3c9b0d39d65897d15e9a21f0e2dabf60cde92c82915d02d"
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end