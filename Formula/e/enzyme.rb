class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.283.tar.gz"
  sha256 "cba7732758d72a0d248b9700e27c17d3c754820deb38ced06ab49c80b1b6afa2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "083a4a6b722cdfa16cf307ca974aea8285f064d9cac3267ba7310194d5fcb4bb"
    sha256 cellar: :any, arm64_sequoia: "6ca3c7de58d144b1a66d5bd190fe29ed0c470e676e3cd99a83b6ab1d24cb53cc"
    sha256 cellar: :any, arm64_sonoma:  "5a689cef81cc020d25837cad8e3528cce65dc48fb567f0678388bf176ff05f3b"
    sha256 cellar: :any, sonoma:        "927491ca5140561993cd8d536dca119dec357debe249e3ee72536e7141ab6664"
    sha256 cellar: :any, arm64_linux:   "c1d79f48f2c457d1f3c7ca9b303ab65ee72e7a8dec174c4603ea073de32988de"
    sha256 cellar: :any, x86_64_linux:  "3b1ad8e0bfe8fd706b2ecc3ef7d1a150d59de0fc7e8e4251a4fc1c3dea31203b"
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end