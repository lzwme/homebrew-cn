class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.110.tar.gz", using: :homebrew_curl
  sha256 "350ff70d870fa5d92fb8e5c72dfea76ad01e9de700f9045dc157636b63c3b546"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ba2e9d68ada4b874b61686a80955472e2196c609b19ea04b8176b9817d98b347"
    sha256 cellar: :any,                 arm64_ventura:  "e60e429f666f0704dad1bb39c26d8870268f01b99a7e782fc36a3e151471de2d"
    sha256 cellar: :any,                 arm64_monterey: "b2772d9c34878f38eaf671b73e3f312ae830ad94563c3cccb62d1f96d38e306a"
    sha256 cellar: :any,                 sonoma:         "06339227a7eec9bfd6f6241697593c61e7da769a117fff846e3bed69424e2da2"
    sha256 cellar: :any,                 ventura:        "09bce3652d2f33ffbdeb000cb0e184fcad102d4353888c6ab0f4163bf63c67fe"
    sha256 cellar: :any,                 monterey:       "61d65d77bb61cbd5b1a4e9e66bb00843dcc49392cd5e2475322b275100f3ae6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00ae9e67aff3229b2eb10284ff990c203a537f4cf9871e60262c7fdcde7d7bcf"
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