class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.209.tar.gz"
  sha256 "17dc773541f2ed0217537c05201bd0d501ca8e2a8081f6a32cb7db99946be719"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bdd33f6be002f3ff7f92f252a5170d101b83b89aac6fb344551de7c68d218f0a"
    sha256 cellar: :any,                 arm64_sequoia: "c6d93f4b1d8c84dcaa516ab7e641b8171f1da480558defdbe2b5f56976518cfb"
    sha256 cellar: :any,                 arm64_sonoma:  "75e1d75f65f950e8b33e1928f68af508406a1b56c9786e136a1a7511e6f1f510"
    sha256 cellar: :any,                 sonoma:        "4f4fcf2378f213c1b24e768ae1fe6ea243c263c7b19d7cee1953fd20490762cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d852d03c746c94d238b2c90b4624d25578a9b742fad375306aba4e314504779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c177a01fba59d14b4d68d1414f8fb46e14b636e9e6de1c23a7ffddb159962bb7"
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