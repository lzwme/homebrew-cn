class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.178.tar.gz"
  sha256 "46323d247ce25fd415a597e56468433abe6a0388ffc117f72c2d9acbd0f52e64"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8cb12b0df789d7b0954d98e07272f93da37955c9dbfc73997e175955552b00e6"
    sha256 cellar: :any,                 arm64_sonoma:  "ac91dd8c3478dba228b7d4601ade6554cbaeac8ea9091f17687c049d372d502f"
    sha256 cellar: :any,                 arm64_ventura: "08b6bf9e83d2c6b5751eb9334d1e99daa245e82405de9a8a6b6f5fccd6f2eb3c"
    sha256 cellar: :any,                 sonoma:        "40069f286a5aac716c795a096af03c6d5be453bbcd234f8a1b0cac282587f2aa"
    sha256 cellar: :any,                 ventura:       "a3e88288ce93570f201bc942740f8e0d4cc87d1ff0f666955c3e17fcd1171611"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04d6e162edaf7413e86f78e42562f065a7cb01ee351614ae1c592d3bd9e91dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df8cfb755dbb8cfe7418c201469db01e258499fb255599da228e9bfe135255bc"
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