class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.266.tar.gz"
  sha256 "174fd65b7aabf6b964582a3785dd638a1ffbf17c195ebd99288e60e58e620236"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "80a09ac27da61502e0f4431b0189e4a6b1a2d8cc595a4fa58dc33627d178775b"
    sha256 cellar: :any, arm64_sequoia: "7ad863c233764ed4b8fabcd04830bcd661c692def9ab518b3ed3a99be57867a9"
    sha256 cellar: :any, arm64_sonoma:  "9a01a6c2c39937441cc9123da5e087e41b561f3c10928b3e3bcfc7bc7626f00f"
    sha256 cellar: :any, sonoma:        "4e5587151cb930f805a6806eea11b98f82d68c1412f5738dc372e154cbbe7071"
    sha256 cellar: :any, arm64_linux:   "c3d0e669f7dd0cca282457686c820cafdd178c55aafd02fb686be6d45013f23e"
    sha256 cellar: :any, x86_64_linux:  "ff834ccf1bfbea128448a2f6b4d297e4f684fe39e124c8155edf791071e8b744"
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