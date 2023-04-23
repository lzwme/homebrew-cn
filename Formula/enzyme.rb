class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.56.tar.gz", using: :homebrew_curl
  sha256 "6da002a01dffac857919c91f7fe7f15fe44987cd1a9623ceac9e503f22fd9b11"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "326b22ff802a420c3d3ace9bc6194f9992aee867da3ecb96adaf15ecd49f776a"
    sha256 cellar: :any,                 arm64_monterey: "e1a94a1c27b0f7086bd3e6d1f7aca04cfc950e08d363e5015098b0d99f631d01"
    sha256 cellar: :any,                 arm64_big_sur:  "c102b74d38617693b8deae95a04d223a1aa7d1ff9faf0fbbf952731171541e4a"
    sha256 cellar: :any,                 ventura:        "3599192e6f2401cd76d262b2c361964495c4fddb75cdf34a5686046165692d05"
    sha256 cellar: :any,                 monterey:       "3c68b5721b940b7024aa95b56a774b4acc170f1737c05b893e9273b61ed100df"
    sha256 cellar: :any,                 big_sur:        "9b5ccd66e75383106d0439455e757bbe27de5ceccf60b91febea523d2481b940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7693a58c998b9fc5c04d5766514bf170f83f287f21598365ca3df68838dd155b"
  end

  depends_on "cmake" => :build
  depends_on "llvm@15"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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

    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    # `-Xclang -no-opaque-pointers` is a transitional flag for LLVM 15, and will
    # likely be need to removed in LLVM 16. See:
    # https://llvm.org/docs/OpaquePointers.html#version-support
    system ENV.cc, "-v", testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops",
                   "-Xclang", "-no-opaque-pointers"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end