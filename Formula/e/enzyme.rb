class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.188.tar.gz"
  sha256 "54d3598b9394fd76d30b3e862e0de6801efb21da3ae2d5144f8fcad019bd1c52"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6781cee5bc882182adfc5aa008f92d0af5eff92fc1d0b35ce4068904c4b0d64b"
    sha256 cellar: :any,                 arm64_sonoma:  "cab3b7690e4b235c3bd32ae7aab301ba8ebd30fb9e1e2cf819bb82efb5717ee0"
    sha256 cellar: :any,                 arm64_ventura: "61e94cc83f2fbc0269d5532bfe4b2875d4b3b73f78afb773fe9aa607731c5e45"
    sha256 cellar: :any,                 sonoma:        "8487e8ae4562510e1e28efb49b2d3b913e8e500e37e8b51c5627b8185ea5009b"
    sha256 cellar: :any,                 ventura:       "7743e47cfcdb7b937c85a0919d4bfcd85add7ddff80f2435451aa90f586fa000"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21aaaa652c887d0ed9a9099d0168ef8f57da62cbf0066cae9db3dbea424c78cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a803c1e027ce9f0bc64a4ffb9b5183bd6540fbb00764e8a794984913c268bb7"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

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