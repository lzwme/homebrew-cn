class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.105.tar.gz", using: :homebrew_curl
  sha256 "d37cd1d9e81c9df15807810187aa8f585034e73bd8bdd114df4802d4f96c1270"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e60f7e1f7a4df3a76ac86c40f3d56a8b3e3724dd6572f9b61c6c7a9fadaa89f"
    sha256 cellar: :any,                 arm64_ventura:  "e56599cb4f02a9bc29265dd0fa60eba46c29d372aa5fc9106ed7bfb15b964489"
    sha256 cellar: :any,                 arm64_monterey: "93b5f231d7f34017735271c9f80c217c83dd9f15731075e39cc1684924fb0abb"
    sha256 cellar: :any,                 sonoma:         "5c9f33ddb1b84bc43156afec70332bd69aea2871ba323ce3eff4bea010c09f77"
    sha256 cellar: :any,                 ventura:        "e424ac71c0425d37fb9aff5bf6d7988c5274ab84d1dcc1b6c19db59257b9c52a"
    sha256 cellar: :any,                 monterey:       "1e4d0bbbfd3a22183d018a1a274a48ba9b693f88ac7cc9770e26f7653139c075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2827f0481b60a68e1a63131768e250dbcb4a28fddee380207aae028c812a19b"
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