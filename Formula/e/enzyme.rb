class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.140.tar.gz"
  sha256 "7828f9c0b069a59cb2b4cb57da33e86c06f5529b19d2ac630948ca37691c296e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "41f926ea2e2ee610a81810cf01ee5fcca800b96a789617e698ae6c8d40005d75"
    sha256 cellar: :any,                 arm64_ventura:  "13676bd01e108d40f3c6452863cd1561129f6c90fb9d140dde587ac73ec0f703"
    sha256 cellar: :any,                 arm64_monterey: "c4356d65d305aa5ce830567673566dbf18677d0c76ad2c0847cb8eb9674c9cdb"
    sha256 cellar: :any,                 sonoma:         "a509070232144d71b215e3f4977f60701924440a847d65440641207c81329095"
    sha256 cellar: :any,                 ventura:        "0a041b75fa7f665e3055bdba9873b62dfeaebf79e9cee4bd04de4f828dbaf371"
    sha256 cellar: :any,                 monterey:       "47de1da7c5f20bcafadc578ab0dccf3496c04c0c62c2d8373d04f8295d6dec5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49628b36b8290c9ea062350ecaa5c4161e03988105f942806c1870a55c61938b"
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