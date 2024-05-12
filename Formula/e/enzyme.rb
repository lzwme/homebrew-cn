class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.108.tar.gz", using: :homebrew_curl
  sha256 "e985738add8d337a3173e524b1f36f16938462a86165ad52359e51a34442f34c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7eff02eeb6d32e2e7c3828dd2e686789ba460f1250530d1e8d2aa6f89e17a2a7"
    sha256 cellar: :any,                 arm64_ventura:  "9e8b13d1f4f2332aba18c9378e3c5a264bfd20673d0e2ac91a1bfb9f057a0e05"
    sha256 cellar: :any,                 arm64_monterey: "7766a83aa7cc452ef563af89006fc48bca48644c68094a41aa0cb2bf736153f4"
    sha256 cellar: :any,                 sonoma:         "bcfd4dc8278f035dca58f7789c7d5a2165de5a43bb3f756ee1b0e5c3d30ab2a1"
    sha256 cellar: :any,                 ventura:        "163d5ae7f4313f4c9c85cf7d001dfbebbbcbc60888910f8329a9469b2e525187"
    sha256 cellar: :any,                 monterey:       "ee2b1a42200353a2c5e6fa5fc8fbbde5d94d01fda99c18483cc02847f1162fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "534baf96b1bb30471eee8c6f8c0e35c5d5b71c9eec20c0368c4c1a9b943c79a7"
  end

  depends_on "cmake" => :build
  depends_on "llvm@17"

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