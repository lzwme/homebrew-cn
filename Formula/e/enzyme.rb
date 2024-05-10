class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.106.tar.gz", using: :homebrew_curl
  sha256 "1b188c5e07ed192538b2ad59515689ff5b4d07b44b6ad99e85c2ed232806ecc8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d394879cf6cf26162f5af6a20ed51074f22569305162587dc621d6a422c9ec9d"
    sha256 cellar: :any,                 arm64_ventura:  "e15131f41ab1a1b30b61541501d527cbc4c78ca2dc392c6da29548f7800569eb"
    sha256 cellar: :any,                 arm64_monterey: "f2f7d4074118fdc4cb84d65107841ae5e19f61db79d793d5b90c4b0b11f452ca"
    sha256 cellar: :any,                 sonoma:         "e99ea1396039a86eba6cf445f5431e7e1890f6bc94057242b1d579269f67daf6"
    sha256 cellar: :any,                 ventura:        "a00c541e5d20c9a5316248acd958fdc73f14545c02ce7b8174353924de608b7a"
    sha256 cellar: :any,                 monterey:       "885cd5933bcb5091b7735386b40d76ec70e0a9d312b591bcbf26125b3a2146a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7547231a2b832a8553e2c5adaab930d7255a8f33687d0327bffea322bb91730"
  end

  depends_on "cmake" => :build
  depends_on "llvm@17"

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