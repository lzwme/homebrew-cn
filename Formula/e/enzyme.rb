class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.143.tar.gz"
  sha256 "ba1adbf1ebe141d61604d93ed5a97f1589e067e2d3d091222b621b43144c93f5"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "74760443769e5967b1eb5e0acdb10d6116a76f0531ce374c112e0bec1c024f1c"
    sha256 cellar: :any,                 arm64_ventura:  "84d9f57e645ba19ddcd1d383e7bca1b5107cfc164afbed74516736aaea92991d"
    sha256 cellar: :any,                 arm64_monterey: "afc177ae8bf31253f143911338e8f80afda7c4ca88da058ad7e9e0a55dd6b865"
    sha256 cellar: :any,                 sonoma:         "509631a7f68b5dfd8fd2ec224ad021436c99fce0226a8b3de8d220129712de09"
    sha256 cellar: :any,                 ventura:        "b3d499bbaed70b4f9c49b871ebc12ab603980580eb1173721194d57be762f4ae"
    sha256 cellar: :any,                 monterey:       "c6370a0e725c263f1513bfd7f43b3148fc897998cc15b89a8f1e48eae20c7df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65861b920bc7dc0a226c47c6ceabc34174a02dc889d13fbf610966d5af17476c"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}cmakellvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
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
    EOS

    ENV["CC"] = llvm.opt_bin"clang"

    system ENV.cc, testpath"test.c",
                        "-fplugin=#{libshared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output(".test")
  end
end