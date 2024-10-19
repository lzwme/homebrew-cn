class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.155.tar.gz"
  sha256 "e4a390fbc621c8b339f1674d3807168ed75c159c96b459f8dba8d24c3d070e1e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c391027722cd67cc9c8daf8049cbb3dc39f298f74149c102119e29e820cf0a84"
    sha256 cellar: :any,                 arm64_sonoma:  "ec066624e64a4cad9b22f0b1f27b8853ff82f575a83244ee963840f12cbf28fb"
    sha256 cellar: :any,                 arm64_ventura: "5afd63c3e3b1814be9717dabd97ea554fd17c54c24b9c6c3b5e3959c79bb49d7"
    sha256 cellar: :any,                 sonoma:        "641ebdcccba96cf168db61518b016134c6d7dd60561326ff8e0e2313db985667"
    sha256 cellar: :any,                 ventura:       "0e281f25396048b2edebcde44dd7b1d857517950c26dcee12dbe0464b18c8195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dda65269cf75260f574dc6e640267fd1205dccbb1228e4ef11cbc8ea63538f7"
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