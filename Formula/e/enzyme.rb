class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.223.tar.gz"
  sha256 "000fdb1ff9964e5931f75940cda6aacf102b1df69e73a4a213d2d3b2dafb20e3"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc6af40bf01a64c418594deeff09c5c445b14acc95ccee162eb992fbc552bca6"
    sha256 cellar: :any,                 arm64_sequoia: "9f468db734259f5df19c2f1aa0709b2d2c06e432002c7b0c80ab86b7d40fb429"
    sha256 cellar: :any,                 arm64_sonoma:  "db5ef8cb18174009c47e42b5e2029575886834184f586b9565e525fabd58a281"
    sha256 cellar: :any,                 sonoma:        "0b1a30e57962014506ad60719ab7f1cf9626cc571eec873d2e3ef4566a95bdf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b26e61b9ff4b53bf78485736c59598b125bc19701f7699627a1a73df84708dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ccf00b9798e2543dbd450c5b7599daed0b97509c8e5e8d8b6ee58706769cfff"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end