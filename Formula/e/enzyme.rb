class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.295.tar.gz"
  sha256 "a26235e72f0aea1b2194bbb9588c0d7349390c1b6e5aa318c950e56383d63632"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fac6aabb1f1f6a43f512f940e76c3f103812d4d9333b831bd754654620c73b77"
    sha256 cellar: :any, arm64_tahoe:       "953fc248ef0b350554134a51749ec552841c56bf97596d53b5724dc2dbc1e8f7"
    sha256 cellar: :any, arm64_sequoia:     "bfe630ae5ef38f0a3ab7a28fd8a8097d50ad7f1131d90489f3d885fd41bb1111"
    sha256 cellar: :any, arm64_linux:       "1d8a96dd29bb96e0cf86668d164034f20c7a6c68a209b028f3eafa4684899616"
    sha256 cellar: :any, x86_64_linux:      "993a959db422d4650927bc4eecf891aa4ce86a9a2964b313b19e164fea6d44f0"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  deny_network_access!

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