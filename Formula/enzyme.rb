class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.58.tar.gz", using: :homebrew_curl
  sha256 "651071e397f8b9b20e5846e44864a002c461fd1ad91e99136d804942d4157c10"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e8f0a2b74e08c7ae01810ae93138669543d8963142a1400eef42109313b1cb72"
    sha256 cellar: :any,                 arm64_monterey: "0f69180fb139294d633071c6485fb000f8cdb528eb0b5d04a12ae1a82b0e6b83"
    sha256 cellar: :any,                 arm64_big_sur:  "122b3787490dbd2bb8cef20481e75623692acb5cd793c547c9ea4c3659527779"
    sha256 cellar: :any,                 ventura:        "cb36f544fcc8f954e6eb9906ee0e2ea179e93ae7d5c4392ce8fd3e61943372fd"
    sha256 cellar: :any,                 monterey:       "ea54f06178e652dfec4e7e33acf83c6dac9cb18b31e51e0ad9e2e8c8959f0fdd"
    sha256 cellar: :any,                 big_sur:        "131b27eeb9487dc342ef6ddce4c8239bb4a8198c95d372eac449af7e127793be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26d4746129acd59497de4b928756c2edc674fec5103361ac32361b4fa04f413b"
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