class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.142.tar.gz"
  sha256 "3201d7b41f7c20b99188ef92516133094357238285bd41c54ef1dbfe44bcf28f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4270d8339acc5b2f250da5d37e5eeef8a69e0c2264996120a06a674001e4ba9"
    sha256 cellar: :any,                 arm64_ventura:  "6f2a1af980c0345859001df3aa3610aa1f9ae9a6f790003ddac66c7b2fafc441"
    sha256 cellar: :any,                 arm64_monterey: "9cef3e77305a51b8690780845cc04420aadb8eb0a5ebf74af88e7ed025a29210"
    sha256 cellar: :any,                 sonoma:         "f3b4b5d7afdbbb60ffaaed2f5ac14f3c69f5f9c737db08980d4b06bbf813f270"
    sha256 cellar: :any,                 ventura:        "711dbacd2365b0e5cfd4e228250ec7867fe668fb1c8763a7cdb618fe275fb247"
    sha256 cellar: :any,                 monterey:       "4ad2be0b5b5961e734ac114f3af1b59cf5cb95d109aadd1ad084eaf2d325ba0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f88f76466e332822f9cf955afda03ea9ccfe1e7ec71c1c7ccff3f8a3dcb1e71b"
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