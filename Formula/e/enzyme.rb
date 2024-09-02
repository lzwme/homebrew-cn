class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.146.tar.gz"
  sha256 "0fe6061a30868bfafe9d72cc703282460c08e0767445f5eed7e10e81d2be583d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d7e7e9c6ae7198d035996a14e6a2096d5fe0f2c0878d22f12c4814d740350ab2"
    sha256 cellar: :any,                 arm64_ventura:  "4135f29b6f2c0ac7b7ba0a93b308e0e5695ba33804924a08ffcbd7fb80de11c9"
    sha256 cellar: :any,                 arm64_monterey: "69fae61e8eecaca7c8f627543330a0b2a59ba98f44a6f192874d4e253b5aaaea"
    sha256 cellar: :any,                 sonoma:         "6d1dd746f4aac2c29e8e821df418218d0dfcc263cf5dee70657b935e80e97eff"
    sha256 cellar: :any,                 ventura:        "7f5159da68b30ced3fc891a2420eb02df5c4bc0fa478ded005bb2faf8dacf509"
    sha256 cellar: :any,                 monterey:       "5f1426808fa2569f0dd28f437e73ec78ea04d9dea3b20ae69e46e863d3a01b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e62dd6bfe1d95729a6b95db0d4794542a752243a64f0928abd5a4ede8f8d5af3"
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