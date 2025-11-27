class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.222.tar.gz"
  sha256 "29a700db8ed456359deeb0a4fc8e0fbca4726d20f55d53788f1d34784aebb8d1"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56c475c8fd91ea0f9d7482cc562c0257833bbe579479ad71c66ed098b5d15e95"
    sha256 cellar: :any,                 arm64_sequoia: "47b0048a29c8ef18cb85ea28c5dcd9b5f0d0ce401a1fc191e62e5f11bb8494be"
    sha256 cellar: :any,                 arm64_sonoma:  "0271f1f6b3a37be57966cd3e47d64c2bc98364202ea455d18bc52966cbcf6cda"
    sha256 cellar: :any,                 sonoma:        "ebd9b86530a8fc318ed7ecd152495bc702b8812d221c2183ab12cd4062c5aec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b93893b51efd343323accc10315b803a84e43dccd1e3933e76a401fdd3922137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "735784c51f470cf144c5204d7ff289d79d6b07e8100296eb97ab343da59bf4cc"
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