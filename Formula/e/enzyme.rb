class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.112.tar.gz", using: :homebrew_curl
  sha256 "c154f5facf1ac7afe010466944b2435d1533b1a4454af1fae8a5092400f64e45"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81685e5a51a60d882202a22d20b5cf90b4dbb825fa595d3898a8c2400b379d8a"
    sha256 cellar: :any,                 arm64_ventura:  "8d5c74c4eeaeae8074ef1db88a2266c89588c04cba7590609ddc2f5522c05f24"
    sha256 cellar: :any,                 arm64_monterey: "ad0639d04d9087c8999c228fab31423ac5f3d800a26e876cd04752ed40e9f8d9"
    sha256 cellar: :any,                 sonoma:         "9486fb5f17788188773faea9b548b7e2bc0517ea1a8edd20b98ac2c671b3f3f3"
    sha256 cellar: :any,                 ventura:        "6cfaf1b3732cfbd659634a07b3c367d5a65b016ef9830fe3f266fee9fcdff68a"
    sha256 cellar: :any,                 monterey:       "203a67103364ed4922757d9f948fa527ba4c279687c6ce9c12649fb8f2ff65d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28f87aa258f77920d6503c1868593396ad6d72e5d70f74dcc500508dcb4e2014"
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