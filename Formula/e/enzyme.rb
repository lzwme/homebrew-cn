class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.150.tar.gz"
  sha256 "9a6cdfef009f86996479d8ceb63bae3341df9f4394c62509d3e8ae2e0cadac22"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74b42077af5b3297de1a73d40564f0134cd3e4200b4b25ba1fa5349ee10174bf"
    sha256 cellar: :any,                 arm64_sonoma:  "e59fc2868ee5f6d7c7c47ec08ad0341bd436e45f32b9d48e8080972b13819cf7"
    sha256 cellar: :any,                 arm64_ventura: "3ff6fb6653d78498ee29f3ed379d7445df228cb2261e725f76c7ad0e3db95e18"
    sha256 cellar: :any,                 sonoma:        "7a299609f039b5d7fc3c5d74aa35ba727d3d177d993a4924950dd297e9e203d4"
    sha256 cellar: :any,                 ventura:       "7be870f50da0b786033dae4ce3486da9404649020f1bb3ff743940f7e391fe46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45e44a19203691684fee565424bc3c35dc80525b2883922f1ee891930b493a4f"
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