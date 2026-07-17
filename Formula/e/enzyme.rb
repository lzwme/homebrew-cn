class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.284.tar.gz"
  sha256 "f710fd59559408c5873452007969819c6722d52356f5ccdaa5fee3c71e7dc2aa"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "046950f0dc48c959deef1edb7ba32ca8762f3571012afe500e95b7678d76657d"
    sha256 cellar: :any, arm64_sequoia: "02c4ef47639376c1bc959f2487e25ae119a193f88e38b7844fa4d1071bdad296"
    sha256 cellar: :any, arm64_sonoma:  "b9b275ab824cf1a5a3e9ae4ea8e44179f830b9d0a94e56a9657795a4156fa7c0"
    sha256 cellar: :any, sonoma:        "d5987070336669af5eef298acd1f4571d54842489ed5f7f781588b5938b03a91"
    sha256 cellar: :any, arm64_linux:   "5bf550b1ca8198f8fab4fd73ee1428f5ce770237c84466b74a058929ab9058b4"
    sha256 cellar: :any, x86_64_linux:  "ecc8a37292823809d4e66cf5df95f6e999300746407289e3b118e411c4b85668"
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