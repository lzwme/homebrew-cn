class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.186.tar.gz"
  sha256 "125e612df0b6b82b07e1e13218c515bc54e04aa1407e57f4f31d3abe995f4714"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4985aac6a072f405b7f154c927e6a7c6be4dff8b376c63cc40ca85ad55dce20a"
    sha256 cellar: :any,                 arm64_sonoma:  "ae20f2d0d2b96e94c9eb4e9355cf4b6bdf96b6703b99d938860b54f7c9c61475"
    sha256 cellar: :any,                 arm64_ventura: "5ca52ad7a187d708d94383df9aa8cdb2aa72e0a771deb8d79abb2818050f9b73"
    sha256 cellar: :any,                 sonoma:        "dfc3cab3f44f41617de13a011c67ae6916531ce238ed4518e773ab2a853959da"
    sha256 cellar: :any,                 ventura:       "e07da40c776971476f12cea9c49ba529773cf48d1ef492228bdb2ca71ff279b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38fc5d76076db7df9a9dbf53215d16f9f2346cc26e617de3a7a4bb2f846ff1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de64af069fffd495c765201695eb4236df51325e21a4e5618c991a228d4372e5"
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