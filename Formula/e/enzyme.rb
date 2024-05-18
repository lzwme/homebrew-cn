class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.111.tar.gz", using: :homebrew_curl
  sha256 "f9c4aebd5288a26269bec75c7ce0548cdbf5af2a011a539a25001816c35fa38d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "23c6693767dcb034ab2c58b1d90b76a9bffd84a97024380f9c0662e08b1a8f9f"
    sha256 cellar: :any,                 arm64_ventura:  "38ea9547da67a0334ac75344532f44b7d4e1b42c3224b220554026b995840eb5"
    sha256 cellar: :any,                 arm64_monterey: "0c1ec792f07b697d8bc260ce1ba7aeef3b7aabc897614c7b9b2b00bf25c12620"
    sha256 cellar: :any,                 sonoma:         "cbd9702a59f211c48fb0884679453ca690735fa4dc7029a3c7bba54f0077c1e9"
    sha256 cellar: :any,                 ventura:        "71bc47b07d49b4d0a073149f462049d653eb244b0ba20710e77fcfc222feae29"
    sha256 cellar: :any,                 monterey:       "4bda9b9910836339a685328117514b53a92f0443aa7d6e09a0a63a875c098565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a0323338f792aba3cb11897cb606330578dee27ab72c2d89768fd17f92a7a05"
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