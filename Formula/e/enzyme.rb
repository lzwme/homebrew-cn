class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.216.tar.gz"
  sha256 "c41f1a1286934f5155614fde0f3c63e0f07bc3b67b8f2ff728540bc862cb8f7a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3ed8c802ac5e2064a258fe7cd3ac793ad79f5c322c5acc0ed738c84a7409c79"
    sha256 cellar: :any,                 arm64_sequoia: "6ae6131b85f1c302cfaafe4df32b3737f26fbda804f3783bf8fa84e651109530"
    sha256 cellar: :any,                 arm64_sonoma:  "e5f51499d3c8a8792382cc5cc861ecc636c0f2bb4772b9c83b6925ae05f14b3d"
    sha256 cellar: :any,                 sonoma:        "72e632ec64c5f89c6611d26272e7c133128348cc9b692c159e47ceff29b37f63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4bb2b1c665600dbe0d0acbc35f47e1ef0732f9192da149a038a895abf059352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4dbdf549aa0916f63453559bc12305d098fcb82089a3c777ed5433bd534364f"
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