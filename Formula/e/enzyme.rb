class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.130.tar.gz"
  sha256 "9624244c557eee85e363821a94558bbdde805f37723da0f3b6042325e279700d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "841633b6ccb496f51c0bf454c53f0c775ddf7f7b6b799fd6a29f6321f03f8843"
    sha256 cellar: :any,                 arm64_ventura:  "ad0be645cd0ce78a61677e34af9822f6eaf13b3280bb68a46dfa2760375cadf1"
    sha256 cellar: :any,                 arm64_monterey: "5d7934a254b7f046c50de4b7255c8c45221046d3a75f6ea9e143f665052d29af"
    sha256 cellar: :any,                 sonoma:         "ed0b0f93594fe0132bf8c5da665dae44d12fa1d3c373325e70639b3d920fd4ca"
    sha256 cellar: :any,                 ventura:        "06bbbd4740e4f9ae9126b71a6d1375acac0c9eeb8f43ca3848dff9f1c4d58604"
    sha256 cellar: :any,                 monterey:       "b7ceeb26a3890c978fbaf851888a956fcd4e9e8847192766e7dada7b68e8f829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba31ac1aa54826a26ce401e43c2ef0b990036cc47443e827fdf8ac763962d206"
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