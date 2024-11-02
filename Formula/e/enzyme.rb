class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.159.tar.gz"
  sha256 "dfdf2b84048f914551ea0c7e50d137b9b6ea0b017542f382bf3960fbe315301b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5325994e4f0a1476f7c593f40d1704782a40459af4ab4efe9c5cd534ff8501c6"
    sha256 cellar: :any,                 arm64_sonoma:  "c369f633b0acac6fc69ed96ecb3726144e831d9c9f3d62025faaec851562c79a"
    sha256 cellar: :any,                 arm64_ventura: "01a64f1ed44ad88d7c93018fe15fc2bd43f92a991a215196a5e22c06b55345e6"
    sha256 cellar: :any,                 sonoma:        "0872c6a396722f9516ce54ccb94d3713898cab436db1f21dee124f36238c61e4"
    sha256 cellar: :any,                 ventura:       "58048868e6d03254db3623f94f2521c5f279ec0aea0f17202874b0b6998c664a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e8dea653e99a9d204df3151ea326900726c20bf0463214917819a0129d5c7ec"
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