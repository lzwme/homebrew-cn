class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.120.tar.gz"
  sha256 "5afde7021c5d2ecf82ce98ecd66e03ac5380047ff388f040f5536bb8e961fade"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "923e81d80ce710c609f1e117d51d5c40a96c007326451a8c6748aed7e5e7e582"
    sha256 cellar: :any,                 arm64_ventura:  "a89789fefab0f15c2e8c194aaf411ebd65d6ec2ce2336e79ef81fd00054f98ff"
    sha256 cellar: :any,                 arm64_monterey: "f8d51d03de103d25767003c975f467dd41d3d608ca0a78d206f928bd1379bc7e"
    sha256 cellar: :any,                 sonoma:         "e6a7ad461e9f2e94521699ab26470d830351e09b18fe811018a84f77d1f089d5"
    sha256 cellar: :any,                 ventura:        "094f9a3115872f1ed53c2c6892244d74f525cb1b98e07d2777a1517f8bcef2aa"
    sha256 cellar: :any,                 monterey:       "9cf475850a00b9fe1c522ce9fd274c3029b7501f1daaf778af6408c9308804b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b269c41080fdf0d06e178f438ee77b7b1298689e90aa4899a5c2a3b5e4a9a416"
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