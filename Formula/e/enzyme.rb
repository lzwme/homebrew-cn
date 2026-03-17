class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.252.tar.gz"
  sha256 "5d45ed391a90ad30ae772fac2dff94b5dddc0ce3436deb7ecfc5947640df096b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32a820c9310735955ede8624f95b17684bea94636be9a989a01dd1990fd297e1"
    sha256 cellar: :any,                 arm64_sequoia: "a14113ea7be178fc8e5ca2c3e940d6c624bf4ac56281a4ba7bc37d3189c6c56d"
    sha256 cellar: :any,                 arm64_sonoma:  "8c8634300c3c548d7420249a44f8c76af04242cae858a54624cd1e0141d6afbc"
    sha256 cellar: :any,                 sonoma:        "8a57f22970ea0f6dc13814d0754484183929ea055d571686031444126b06e636"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "858ffbe410b9e30350bf392fa8c0eeb55a256eff289ec63d097cdaada1a7ba3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d39eadb6ead3aedd1daa834211d4514c50d4f388c53ba41cade37eb790859471"
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