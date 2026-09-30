class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.299.tar.gz"
  sha256 "13f4f1d97021bf19bf2608f29e6f2b63cf29a7d4b5452dc6366246c6aba3a1b7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "50c9082bbdf223bef958d65a857221ce0543c1e8d805d1dde11c813765d95a3b"
    sha256 cellar: :any, arm64_tahoe:       "2787241800ed263bd00ba522676812a1feb46ae90e87277d686c4d91444ee21d"
    sha256 cellar: :any, arm64_sequoia:     "2a9be08760c21e64f7f73e2c52c5572caf0438a595826c7996bfbecf39a09892"
    sha256 cellar: :any, arm64_linux:       "063c91a2605cd9e687dbbd741ede6ff297155ab28df50490badbb634610ab3f8"
    sha256 cellar: :any, x86_64_linux:      "2bd727835bdd6aa345e8703bc51a6f5d67547106c74d779c719709ae8b522a17"
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