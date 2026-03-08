class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.250.tar.gz"
  sha256 "ab39fac9794803dbb3f812ef705e7979c819a0ff0cbdd704fbf7ae1bd47157ed"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a855dda2c926deb9fd8322ae5ffc1cd9a95670ec9fac587faa550c5feac43f6a"
    sha256 cellar: :any,                 arm64_sequoia: "14c2310fb6bbe4c451eee7acdf307a078bc4c509a25d313b5ba40c2122f36b56"
    sha256 cellar: :any,                 arm64_sonoma:  "ec5bb7770d664d1d566e4121c744cf2f2ef27795476969e4d99dfe5500abe795"
    sha256 cellar: :any,                 sonoma:        "3d00a94faa90773d96cf8671d0e6beb8fe7d50a5f3ec99cc017d5abddfe33991"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a12d5ba158d8a6b5e1d37308e3b1a0742fdf644a519f6afceb6e0428331a336b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a2c73d89832b46b9ac4ce2abde8681778363667720396758986ecb97ad9019f"
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