class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.161.tar.gz"
  sha256 "ba836f9c0b530031bda139bd0cff75658aa26aa9269d700a96081356ff6602cf"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a11a48a29a73d6aa2925fcaf04727a1f88cda8b676e66b7cdc8264456dd5827a"
    sha256 cellar: :any,                 arm64_sonoma:  "bbb996752b8b73481395c5a7cd432ba424129a37454a0e01cb2c5a3ee2f20526"
    sha256 cellar: :any,                 arm64_ventura: "8628b3a0fcdffc58f217adebe41650368c48f2fa8ef539b58611088e02ac920f"
    sha256 cellar: :any,                 sonoma:        "4aea2c3097fce94c60e8dc271ebc43c6cf8e9bf261c60b62f3d88c5e02956f10"
    sha256 cellar: :any,                 ventura:       "81903e827cdc3194b1e2d237c82e7a6d1fa661d317df3b17d59109bbc5e1d623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40f8eafe303974164c11f32d2523293f7a926d11fd58b68d52e02557aecfd2eb"
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