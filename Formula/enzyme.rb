class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.62.tar.gz", using: :homebrew_curl
  sha256 "49e96126d54346b95c945941dc045a78ee624491ba87945ee93a003bbbcf4def"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bbeebf8beb529bb9a46a745605535401501d29d5639a37df3bd6136902a49d88"
    sha256 cellar: :any,                 arm64_monterey: "8dbafd99210fb95f5de30cec2e3461e89dd77c6b7a47984485dcdce14339f751"
    sha256 cellar: :any,                 arm64_big_sur:  "d222b6301bca41dda641fa2eaa3c70ac2a5a519da35a6c97a1fcf42e842bb29b"
    sha256 cellar: :any,                 ventura:        "28e3b594b4dab8ad1334ec6d8a40782c067d18634b014f156a8b74c4ecb74eac"
    sha256 cellar: :any,                 monterey:       "c6f185736cb8bbade181a3961f13d27b7bf959eec2bf3efd8e39d26a1f554e64"
    sha256 cellar: :any,                 big_sur:        "42425578e14ca1cbec2941e374824f21bd87b423a8eb3bd53dc9d7253b13254c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3987958a6e7233ae04a1746b52610077ddee4ca762728b5b2c6cd46ac83ceec"
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