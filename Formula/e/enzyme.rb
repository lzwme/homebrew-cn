class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.181.tar.gz"
  sha256 "0a607f5aaf409001925f7409546d4aee9b957816975fc8115a6b6e207d13240f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "44a9ddfe7222db6f45006ca9f0e6c55400aba08e92e6edcf9e8f79be12fe66ff"
    sha256 cellar: :any,                 arm64_sonoma:  "eb61ffa72f72f8b73d9afb31c54f6bc15bdf96eb52293b7c55503e51616eefdb"
    sha256 cellar: :any,                 arm64_ventura: "b30966b07911c685f55c09f8d4730c3bcbd6c7fa788f5d07ffea4f17c45264c5"
    sha256 cellar: :any,                 sonoma:        "1561009830afc2caa2547f176a1d346ff3987a3e1db33c5b2b451d17707b4bad"
    sha256 cellar: :any,                 ventura:       "991a4f9d1a5ef65501739d74be28af8fae182e308471e29e4b30fd53c8876ada"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "407ae3267bd6cabd5cf4538f96d5e1ae87a8b9d97737779937510504db78f488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a267136768eabec31aae03f2e837211f6b64c939750d19aa6bfa874595f3c9d"
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