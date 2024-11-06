class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.162.tar.gz"
  sha256 "a0494c54b40b2d0bfc8c017258d538f073fe97989700f6fe703deba93f686cf6"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d779b96f63bd18eb347068b62d1de77d08ccfe4293c7fb4df89f1746ebe11f1b"
    sha256 cellar: :any,                 arm64_sonoma:  "002daa6a0fc1bb9da6d3d2e021944d4f30f312f2a7700747227167a420b8d933"
    sha256 cellar: :any,                 arm64_ventura: "0ad400dce02bafff3863ddd67679a2dbc3a6ec7094e85298ea4f72acac98bc79"
    sha256 cellar: :any,                 sonoma:        "7d8fc527770523ee258f1c2fbb3258b76b668f6e01ddaa7691902673d7af0305"
    sha256 cellar: :any,                 ventura:       "357b03b316b7511fe3c04279f7d78e7a282085007ac0c833615c9023cbec6944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d8a4d042bb44000f80e21631aa961fa3124a02d340460abbee99d553f81932"
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