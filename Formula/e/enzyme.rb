class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.171.tar.gz"
  sha256 "6a9a9c48c36124912fb4e2326d896032a313490788833460f2699690604f79f4"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5fab47794a5d32f7f60ab1482bcc86358fd8e08fc85fe764705484ae5d3b25b"
    sha256 cellar: :any,                 arm64_sonoma:  "dd93b90338ec9557e6b2b21ce4ab62e440174da71e084b2357729b69b7ab6ec4"
    sha256 cellar: :any,                 arm64_ventura: "7978a834d1eba63e3f415328a77608f5a8ca5b8463176a73304ff3cfaf65bb9a"
    sha256 cellar: :any,                 sonoma:        "331e07f7040dac1ac457df71d6ad49e37a10a7970a1456fa22e38bf8f6885b1a"
    sha256 cellar: :any,                 ventura:       "3052217ae50ff2af3e199c9bb3928fbe9b4647e53f7bb083614dc1c3be079274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ddb626552b06c7083e6c79d4a3a99e75f5ced550f3b7b1fb109100fd4ae5f3"
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