class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.263.tar.gz"
  sha256 "00d1304fcdee6bbf1f28014b14ea7dd494a0fb12025e279c98c792616ace9562"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97e3eb07fd75ee9668df1d1bb8da38f5a778cf3eeec0e6655dabd611529a852f"
    sha256 cellar: :any,                 arm64_sequoia: "5d1d79975a10fd49a785f3111190e5fdaa275d6cb16bf0d52f157a7dfd9c5aa7"
    sha256 cellar: :any,                 arm64_sonoma:  "c366ecc5d0388f3ec630f6e8ecd93164e7a7d6f13028bd8caf73495783755084"
    sha256 cellar: :any,                 sonoma:        "4223844e2e2ff34f68a3b6ed91bd85a490526f42642283ab263910340a26559c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cee2a4b5eb4075ac91c5ada67520abae9255cf5ee4a690f3e09efd31e6402e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661112e9cf29042200273a50a06ebad46e1bcacc043f89b6b4f7d8ae45d2eb22"
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