class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.166.tar.gz"
  sha256 "a0d8d07ff08da8f09cdce64b9ece780831a32776910e76064590b8802c312beb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46526085b4a3f362ff666f6a19fd5e0b72b5aef2100f8ea999dc41b7ffe0ca46"
    sha256 cellar: :any,                 arm64_sonoma:  "aa4d4ff0bcd0198960e7657dbeb3425495614681f90960d7dc291cca889e6336"
    sha256 cellar: :any,                 arm64_ventura: "0c1b7367f6bc66ecfd15646e6b04c6d9bb11e6354c9ec99cd9fe1f21004bf267"
    sha256 cellar: :any,                 sonoma:        "a980b54adba51e2bef2a94150bdb3e7117a56d3ce3f8a4097d2490cbc6b2f82d"
    sha256 cellar: :any,                 ventura:       "3cde4b2f50dd722a78a52367487675394ccd8b49f5c751f37e7e62776a009648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5911772b8ff113d0e7b7a10621b0150ec68f522a20f85d1f2862d4db0b34442"
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