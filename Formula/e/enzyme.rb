class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.297.tar.gz"
  sha256 "5eeaca15d153609904f47a3058dd9edd7a3fc366cb9bc010daeb1f32adb7493b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ebf05012d12a89cf4df33e34dd24acfb73fad57e62123dca8693b5b9d69474d2"
    sha256 cellar: :any, arm64_tahoe:       "f402044812e5e39b4606cad8b4e9b1b0b519924a846f91e611544cafc6d4fc15"
    sha256 cellar: :any, arm64_sequoia:     "3c19633a8bff413953429e2fe3b3055049dd8ce01505db4b9d032ba80c60de84"
    sha256 cellar: :any, arm64_linux:       "f310143d997e1b67c8049a851cae6cf6bcd45acb1c84ab4634359a973278d5e1"
    sha256 cellar: :any, x86_64_linux:      "0ab20c930700181871b87c74e77d58092e0f9a8485371aa246356e58c5c8e460"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  deny_network_access!

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