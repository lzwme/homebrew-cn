class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.183.tar.gz"
  sha256 "ea5a0f82d2e738aa2bba984e0117bda8d5db2a4a195c8ad7a32fa0c882ddbfde"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5899ba70f888c1071aca62e1d3488e52de223fbc06cac0c6501b9d04849d00d"
    sha256 cellar: :any,                 arm64_sonoma:  "5eb70a8f3b5cd2ade6ad95ecaef8b01d0e9dadc25504d62bd49cf0ea77f76770"
    sha256 cellar: :any,                 arm64_ventura: "2e8d01fdb157b8b83220c27610e00153dca16d63a4a3528248f8a602e8337581"
    sha256 cellar: :any,                 sonoma:        "cc9df88089b398ab7319f813b6b3162faf369fd70b20fbf1e77cf79ab0faa9d8"
    sha256 cellar: :any,                 ventura:       "87141ba3b614333f819e6ac3f45920badfa3249437fb6d53ed4bd373f4d5dc9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf8c3dff8fd624c898f84ab779d19b82764ae83a149e4c59266720839b64f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62fd2507ae9f4b26582cdf06a0b374edfe97023354a2c051432dab1a0a2a799a"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

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