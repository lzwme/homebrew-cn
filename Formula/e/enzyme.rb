class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.170.tar.gz"
  sha256 "8d39276744d57dd0d943174fbbc51dbc48a3ce4c2e767d28ebef62945b74e8a9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "76b3dd10b1ab6ff49dc8dbd9d078e9f212d2e2454ef1d72921812c99fc09a8b2"
    sha256 cellar: :any,                 arm64_sonoma:  "7cee199a00d273b4f6bf97ead37ad43707845ecdedf52329e0e4554b31ec9cb4"
    sha256 cellar: :any,                 arm64_ventura: "91b6031be77c4dbade4c5957f47471aa8cd19db8735c877160c2b6f89126da3e"
    sha256 cellar: :any,                 sonoma:        "81cb57b1b252770093ed39bcf0c3853ff4ec725ccc7dd6fe5ae48109b7869cef"
    sha256 cellar: :any,                 ventura:       "67b87b39f2bf36f3dbfb4e9f44aa6439d5dd767b51dc95ae109d441eb746dc83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c58f45988c43787405a481999fcbc9b9c60ec35c120459988c00e397b05617d2"
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