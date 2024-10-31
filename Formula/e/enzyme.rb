class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.158.tar.gz"
  sha256 "198e01def5b50128ddda9d418ead43119f618b73714abccb186ce4654e581d8b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "80f6d623e9f899c09aca9cae2e4240584d79599248dacbd0b37850df886a1a58"
    sha256 cellar: :any,                 arm64_sonoma:  "2d7e0dfb67771c453d88ee0dc53c57921cda3ffc990e1c3758c5d52331866c67"
    sha256 cellar: :any,                 arm64_ventura: "29e42078dc3a8e319989141548e619143a2e81c863ce778093a4fecc40306c00"
    sha256 cellar: :any,                 sonoma:        "d15593a1b73e3f2020919e2854def93b8ed9e8840f4d0e5fd262860319fd46d0"
    sha256 cellar: :any,                 ventura:       "f0c1fb7089f73d12f8473764d609478128055a59922f3699c59f3366bdb6ca92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6d60d690db91a0d0be032d22d08cb963bc3c7099e8559e043712a77572eaa49"
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