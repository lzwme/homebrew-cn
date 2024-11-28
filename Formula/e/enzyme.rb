class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.165.tar.gz"
  sha256 "1ed50db7ffb3db450cc7e93e2ec8df422a90631d32776e292c13455d9128223d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e5f542b1c3c0f04120efa9917411296b6c30a136ddbab882a221788382a629f"
    sha256 cellar: :any,                 arm64_sonoma:  "34166b40c58d64431e9f4b7ba8ab1f3f1a0e62dbbec7b77bdfb77caa2c559bc2"
    sha256 cellar: :any,                 arm64_ventura: "e337f8c15ab6b9a7b5f3f9d48e30258806f3823650770a42378bda0fabfedc9b"
    sha256 cellar: :any,                 sonoma:        "2b72f2a9541a5784bd41660409383afdf4690ff184cea6d3bd0ce28057ddc854"
    sha256 cellar: :any,                 ventura:       "481fc124cf25db05c8059d92bd697c14cc58ca60ce8a8b1d72ba5fd42fbd8c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2220c385deb4273b53691a2d5ec5e745ba40b7f75ae29d5487259f49afec262a"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}cmakellvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
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

    ENV["CC"] = llvm.opt_bin"clang"

    system ENV.cc, testpath"test.c",
                        "-fplugin=#{libshared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output(".test")
  end
end