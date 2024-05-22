class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.113.tar.gz", using: :homebrew_curl
  sha256 "2bcaa88cd825033069a0a49e26aca6b4b07508b2df0be5c63486bc1325158911"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1ee1b9b08312016e1202d0da53174d2409855902c1ca1a346661cd6149e8866b"
    sha256 cellar: :any,                 arm64_ventura:  "6ce9b080bc8910bc0a6af37251e26b295f85b2c4c29aa67ef4aff139909848fe"
    sha256 cellar: :any,                 arm64_monterey: "153809b76f243255e1702a27fdc4f2733bbaecda533d0717e507ed23958c3c84"
    sha256 cellar: :any,                 sonoma:         "9c50c6a2a5d0051ae5516ce088070e4b4393c192a8225658e097b70875836d32"
    sha256 cellar: :any,                 ventura:        "fc492004ca5f0b06087d738dd2943ca7ab1c3ccf8b5c1d4c055399f92ff36050"
    sha256 cellar: :any,                 monterey:       "1959f7bd65e61d56c3b07f5fc971ee8cd28d087afe365064bbc6eaa3d2b05d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b3d0b3ae3a9e12bac0182df0fb191714001ab370462097b04e84d18521fe92c"
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