class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.287.tar.gz"
  sha256 "0a863860050b1477bc4870deba977c7c03810da4472c3e4f8415cd8aeac2ae4f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c708fd70379bc928c8ec00f3c7f810bedba53031c8e4ea3f6cbac2edd9cd55db"
    sha256 cellar: :any, arm64_sequoia: "50f8b0b1ae10ca3ca78bc00f079408815284e8b97e825f21e41f9f59cc27ef10"
    sha256 cellar: :any, arm64_sonoma:  "917c545d65ad653ab5f52b36fc5b42579f492a9ecf8143f581b2da0724918ebc"
    sha256 cellar: :any, sonoma:        "639cf8a9b432e3c6dabdf8f7a39dfc8875187646dd75b50419eb5ff431ea88fe"
    sha256 cellar: :any, arm64_linux:   "95bed2a0ba64555f5d13aea31a9d027004fe56101d64b526262782613cd0d183"
    sha256 cellar: :any, x86_64_linux:  "4f3126ec43815b48bee263e8b4bbdc690690eefeaa01724db62a8179ad812a64"
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end