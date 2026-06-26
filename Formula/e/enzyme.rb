class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.275.tar.gz"
  sha256 "9340985a81dfa101a876f58bce087e6ed3a589451b3bb2ed19b334657143882e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ccea2abe51826904245570acb30025766c1e465988830255ec7027cb89dd1fa"
    sha256 cellar: :any, arm64_sequoia: "d47a5f98670e9a558d2c1236698594fa23cd33a4d4164b211e2fd638fb678cb8"
    sha256 cellar: :any, arm64_sonoma:  "a2dcb52bb48d2694bb1f7f7fdf2e5ad7153bc9e0d7a0e26a88bffc3416e6f5eb"
    sha256 cellar: :any, sonoma:        "6692e7d9b198bc98b5d5d6cf9127a6d06db20d7574417616dbd89f257bbc41fd"
    sha256 cellar: :any, arm64_linux:   "f299f8f9564a45ed0aa7ea1243e7abcee65e0893ab37f0c0b0838884948c8fed"
    sha256 cellar: :any, x86_64_linux:  "9b46fd5a53795795179d11f43e3ce2bd0bf1ea5b74df7104d1dfac8bdae39538"
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