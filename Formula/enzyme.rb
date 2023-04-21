class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.55.tar.gz", using: :homebrew_curl
  sha256 "65acbc4e6eaa88da51870250fb23553db473c6b2de43f83f700381ddd0c23ad1"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83aa2c41755780398c1c6da8a8810ab710da1604542d9ec8befaf29855734a1b"
    sha256 cellar: :any,                 arm64_monterey: "f0babf8697a0e37cf22b970baac1ebf626a3147d2b627c9c709d921c87d55fc1"
    sha256 cellar: :any,                 arm64_big_sur:  "8f8c0c19eb31bc9c8db82c7a6d297c0c34868c94299f05b3da750fe35a5da01f"
    sha256 cellar: :any,                 ventura:        "5f36b6d3569975c2df4d6a8286c7d7abec79f3c28f1c88dbb6d5624cb9202e2d"
    sha256 cellar: :any,                 monterey:       "bc20b48bdc112b2eabdc4682ba735ad44d33c70986434267d82c2e9fc8a1c3ca"
    sha256 cellar: :any,                 big_sur:        "a53e7f88cf21338d868636f2e2e15fc31b99b2be1cfcb70c97d18e7c4b20ffdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69bf3dd4e5b24eed28d1b91f4456043cd8ac7ebc9090b2105b63c1cf9a76986e"
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