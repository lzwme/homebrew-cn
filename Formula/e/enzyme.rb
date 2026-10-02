class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.301.tar.gz"
  sha256 "60df9b636c6ecd038d8f99cfe51dfab78565b1711aac6c6a4cf3f05f0e1dfe85"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "737075bc2286c157d748a2e98854d51c61340dd0b0becb2a6851abe17e34afc5"
    sha256 cellar: :any, arm64_tahoe:       "31a765fb86c3e4e3c92dff8af1512cd240efbbd79026d73d3f2eae49fd7edb03"
    sha256 cellar: :any, arm64_sequoia:     "47bae4df543bdefb3bbf5064f572fd80e6164f15bd6b0a76d8ec3be2bc5ab3af"
    sha256 cellar: :any, arm64_linux:       "dfb9603574c61a4177f962a795bd96bb4a10e2ec74ece53eed6c4a2a10cc1465"
    sha256 cellar: :any, x86_64_linux:      "0d2ddfa02e618b3336721ec0030edca150780d6c611bc1d1d91caf565629925b"
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