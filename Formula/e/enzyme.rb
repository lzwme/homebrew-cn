class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.268.tar.gz"
  sha256 "52a15627b953d8836ffbabe4ace7d756e9038cfe7b345675e53fe069d945d3b4"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a1b93e0d23fa9456eb69150d2bbe787e9a93d01bfe7456d7f15b88f5eff561bb"
    sha256 cellar: :any, arm64_sequoia: "82a613f1a0bc15b7c7c4cbb1830c92db2a2f8e90659a79366ebdbe535d7e3335"
    sha256 cellar: :any, arm64_sonoma:  "2565eb80936880c524c9a3fe6dd6cd31551fd3d70a95cee21f443f946a9646cd"
    sha256 cellar: :any, sonoma:        "0bb78ac4c1acf968c6fef2cca4ff5d6e7f2527484ee4228b1a10ee301c498fd6"
    sha256 cellar: :any, arm64_linux:   "ced31c05c7616e4688724e156af45691ae493012ccfdacf1eee5d5a3a43a604f"
    sha256 cellar: :any, x86_64_linux:  "913d5722f6ec4789336f665cb89c39d70c2b2f608d432477b7960d45a4fb28ae"
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