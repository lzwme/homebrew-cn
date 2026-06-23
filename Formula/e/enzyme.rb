class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.273.tar.gz"
  sha256 "3fd1ed2000307e5d9ef7e2e64ff72c1b2fc025ea001f5d4c84cb423155bbef89"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cd3422474e3524e43a37682a861e28c055ae07f1e965de808da74828c208bdda"
    sha256 cellar: :any, arm64_sequoia: "1414c52a5a13bd37ef0566b6573c71302d0d18fdc86ab4f12c5d4d38ffd3fdfe"
    sha256 cellar: :any, arm64_sonoma:  "3b2bcdb69194653c2a90dd56ce671e5483272539bb4d6e2b16b01331ccb60a2a"
    sha256 cellar: :any, sonoma:        "74cae58b6d6aaf053d443720678a286af66f7ad8307e9858c5085c909011b178"
    sha256 cellar: :any, arm64_linux:   "c5e4bfd3b4458832de083df2642839af532ac3eb03521ab548dea77e3f215db9"
    sha256 cellar: :any, x86_64_linux:  "aee7787e4def07c9731bdbf0d4f20f6b89a001b8a53ea8615cd198e29c3dee41"
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