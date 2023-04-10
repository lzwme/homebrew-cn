class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/v0.0.52.tar.gz", using: :homebrew_curl
  sha256 "f73666be7571b36f2a68ac0ed2d61b27fa45c5a82869e8e7c60c9a24381ba2bb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f6808a4f12856525718591c6c2c5d67425498ff7278ed9882bb46c6ba8b9a63"
    sha256 cellar: :any,                 arm64_monterey: "c8c043084375b4eb591a5219897597b313c057f950fda628a48a4e364b8efaaf"
    sha256 cellar: :any,                 arm64_big_sur:  "82250e3b37215f05b0bed07f8373711f05b066ba2a4ff694b5f8cd3911a3791e"
    sha256 cellar: :any,                 ventura:        "e52d6ffbe782585bafdda820fd1a27892783772feeb6eb52c32ffdb39f1583b0"
    sha256 cellar: :any,                 monterey:       "4a626b8afd20eca220c849d2e12d47df3c336c42e9952ceb75a47bafcb336693"
    sha256 cellar: :any,                 big_sur:        "b47f0265924f06382a8fba49607471402d1e47bd094e23866d31b6c3f2be9c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "723561364d42e72277df7ecfcfd45c256f4d190a0c5a3ef01c53ce7e0cec225e"
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