class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.234.tar.gz"
  sha256 "146b6bced9a7fd7fd94d8f25e297ccf85b1d3ac82b69e5063f73586ef71df9ae"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e10425015d50de50bbbc9461ee249dd35e1c26d13432ed7121f80079cb31dee6"
    sha256 cellar: :any,                 arm64_sequoia: "1899ca82d49e64a852512ea8610cb0ce86440e06c8cd721b485254774e8103c7"
    sha256 cellar: :any,                 arm64_sonoma:  "926012f6d4e15da70874d7574adf119d00cd014758658793e921756d71958698"
    sha256 cellar: :any,                 sonoma:        "c16a76903feac1404a9bf2351b5a734567a05484b0b4b3bc8f3ec400f766cdbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c498b170f537302d1a83538ca27b50fd7f08e02b5d917b25059530fe87da202c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd566e6cef8351a9afe5be4fef5e02eef2b0a9e2575e99ec7bca93ba4f37ded1"
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