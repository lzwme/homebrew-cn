class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.63.tar.gz", using: :homebrew_curl
  sha256 "a6230459da841e0d3af7e82f7f72f8a40da8ef392625c005f97389b532878375"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d86c57d98939ac8da03ffad2453389e7b171fac96793a17954407e8111415a6f"
    sha256 cellar: :any,                 arm64_monterey: "41bd3924a12a702ae6b7636110ef4d560fd693ee2e5e1938e6b38a11e507559a"
    sha256 cellar: :any,                 arm64_big_sur:  "b2884b0e6a7b6675f784b7a488e1cc079555276ce7894c0fb0884d6f9ec22c5d"
    sha256 cellar: :any,                 ventura:        "8c6ba5af2eca9abaf7c40deab7b061f2622a162bfb93f8471a55e2b747f2f433"
    sha256 cellar: :any,                 monterey:       "f6fca92bdbfcb25ca1f7dfd852483c1e076dd42074492f9647a47db826d808ee"
    sha256 cellar: :any,                 big_sur:        "ad0f5f9496b241d0a174b52bae15056051a768402f769bde38517a572933e7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6f2b79a45b16aa794d40172635128ce53baba6ca686db70ddb323523af083f5"
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