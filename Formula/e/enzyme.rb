class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.180.tar.gz"
  sha256 "d65a8e889413bb9518da00d65524c07352f1794b55c163f0db6828844c779ed4"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cbe85e04020ae01879dc63d5f5a8c247738f1068e759dbccbf08b120702969d0"
    sha256 cellar: :any,                 arm64_sonoma:  "d03c634c123ccc1aa26ad35cad2f4ec8277b48f2300d216ec85b0dce23d4d4f7"
    sha256 cellar: :any,                 arm64_ventura: "dbd1d88feae9393189a899367a0792633d009b2978c40ee49676f25ff096e457"
    sha256 cellar: :any,                 sonoma:        "2fefa6ace6592f09f45001107525cb3d784989b577b18fecf59c12e13c0260f1"
    sha256 cellar: :any,                 ventura:       "5d0ba7f4e90315c55cdf8702f218cbab69a091b2a937309353e82142692973ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03919cf7f351bbec252dc0837c4816303986b5f34dd817899036e326784862a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1645fc2c0a130ff1bc58c8315e28dd90491c3c22faf3a8c66cb2f0bd95e96f46"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

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