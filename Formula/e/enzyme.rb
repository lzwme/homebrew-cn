class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.288.tar.gz"
  sha256 "ad313a4769943a8994d45d47bcc11f313aa44a569dea87d4aef7df0274288310"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f8ea474bd01213f141fed9af4828b3403a0d27b5484d757ad40e01eed7db632c"
    sha256 cellar: :any, arm64_sequoia: "534d5fe342affc86be00d0b63a73eee2a1170cff9b96fcf3e2ff693287eee09d"
    sha256 cellar: :any, arm64_sonoma:  "8b7227ef7f8113206b258d7cb8b3fa4fca6ee368a0a995617b3e029c09f24c9c"
    sha256 cellar: :any, sonoma:        "fe80c546a802fc3304f8dce4b4765f23b97f36ebacf846a5cb89264fbeeefa9f"
    sha256 cellar: :any, arm64_linux:   "28137943bd8e50e0f608403b74d5c0b5b1077a77cb412a6c352e26f368df2b3c"
    sha256 cellar: :any, x86_64_linux:  "8a307c9435dfc6cfa516dd5c682feb40ec07f44b1e1baaff13cc79e1b4dcce33"
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