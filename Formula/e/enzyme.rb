class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.117.tar.gz", using: :homebrew_curl
  sha256 "516d5c85bbf5be0b36451df439f681e52e9734006d05953fa75b256c1929e122"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7331e1a406536ca04b8a3681cab0efacc8c502de7294c1319cb716d3ed962d4b"
    sha256 cellar: :any,                 arm64_ventura:  "770b8df715aeec4dd418cedd5ce628975ce6aa8c4f3b53dd7aea072d7bd538b8"
    sha256 cellar: :any,                 arm64_monterey: "6becd4c1f3ac817f5248883423b11ec0bd13ff8ca91242928c0fa76c45782fc3"
    sha256 cellar: :any,                 sonoma:         "1d1e78a6671c0a6a3e9e55668f3e7ed0d222e893801d9a7c7170a99e3839702a"
    sha256 cellar: :any,                 ventura:        "78d90d4d5660e7db1100459a4507494aa8e40ff3f7fe3833d00ed5ddf11e841b"
    sha256 cellar: :any,                 monterey:       "134fd64807dc4d97ff2f3cc0ad7a333ae572dc65200a52001641c3d74b7da42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e90d49ab34f1b3a3b3389a525eff5d88c288e933ceac8bec06e6b031d893b6"
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