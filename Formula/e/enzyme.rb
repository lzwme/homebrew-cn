class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.282.tar.gz"
  sha256 "2587309b363857dc5229fe3ecb13ec10c9b04014cf1711bcb026b8bfff0fec6d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8c42b27790c4f7e00c9e17594244796af1972db7e3ed5c5e33c319f7d1b10404"
    sha256 cellar: :any, arm64_sequoia: "6d9df25bea57476972a20f88da6828b6d65064f6670df879657d73910344b383"
    sha256 cellar: :any, arm64_sonoma:  "bbfc25e8aced138afb03d590b995b0bf2ed61f08cfadd404dbf4e8b5e3fe5520"
    sha256 cellar: :any, sonoma:        "2c57fbcd233e83cf91b7aba2a18eb78a486c403cb325414194236d49ce766d39"
    sha256 cellar: :any, arm64_linux:   "3a0290000b6400ca245a64972b9f4f19fa043e4ac193cdd26d237f22a5d9f812"
    sha256 cellar: :any, x86_64_linux:  "9f0da1c3d3142826c623cbcfb05ffb8eb4b0e566f181606e47a11ac84e70e18c"
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