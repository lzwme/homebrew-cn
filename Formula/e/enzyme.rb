class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.274.tar.gz"
  sha256 "45376b6b19d836dc92f893bc8d657413b8e6cb6dd7124cdaefaf366e8c2de445"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "607ebe28dd1a81308bddc137a54bbd11240a791b4b3b017c23b75af2ff5cf960"
    sha256 cellar: :any, arm64_sequoia: "62184e03fc27f7771cb20db4123932f4eea22d6434011326621d2c7a4483b206"
    sha256 cellar: :any, arm64_sonoma:  "42603a51d7812e9b96f438a281e6ce84aaa3dcb114dcba77bbea32bc91f8c45a"
    sha256 cellar: :any, sonoma:        "7883ffda2cfcf10d313a394ac008587c2cd814511d4df37f9f4fce81b6a4b9f3"
    sha256 cellar: :any, arm64_linux:   "b69feba2dc239fc4359a52d71f82430ae290fe8040a7a082911fc62f12bc910e"
    sha256 cellar: :any, x86_64_linux:  "afb1713736202a2d880b4d7f99ee9a56075e5a855ecb9b910688e5b64779cefc"
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