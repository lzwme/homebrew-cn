class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.270.tar.gz"
  sha256 "6af8141c60f4670240a123d72aa66bf37cf59b0c3992088c9067fc6212ea542f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "443c09bed624e30c5ee008f85569fcad65a9161f1539c43bc7d50ffe201d02db"
    sha256 cellar: :any, arm64_sequoia: "4d86f3ae048913ccbe58464e2f1297a4aed2196d2243a319c573685e935d6681"
    sha256 cellar: :any, arm64_sonoma:  "7a151c73a1e859804e7feb5f5e071cd9b19bd4ed7be54c566b1aa128239fefa3"
    sha256 cellar: :any, sonoma:        "d1edb5c89a0cec063d362fb4a7b16f63a6db9d25ebad2909bdfc36de321a39ab"
    sha256 cellar: :any, arm64_linux:   "4d11ea3701d510fc12d28dd794efcf2337d3e000d35b888a3d21af881c41b64c"
    sha256 cellar: :any, x86_64_linux:  "0efa3d44bd8e3aeb67a30b9ad2f0ae30035c19457b5c4ac680a475928e4528d5"
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