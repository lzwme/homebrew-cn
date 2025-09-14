class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.196.tar.gz"
  sha256 "2b9cfcb7c34e56fc8191423042df06241cf32928eefbb113ac3c5199e3361cb2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e12301478905b2ff73e6ee16ff2f29b3d4af7f8ecd1f6d8ff275f5a986f8a72"
    sha256 cellar: :any,                 arm64_sequoia: "44815ad6c9c00b918925c0beded1c030ebfbb7cc53219ffa3c576c6344a36b70"
    sha256 cellar: :any,                 arm64_sonoma:  "31e508dbac9c87b85940114b7b141c60835498b51445e0c76b7ce5d46e33842f"
    sha256 cellar: :any,                 arm64_ventura: "c4964e4e5dbf57510019196df0b181522653b10afbf48da082138718b8c23403"
    sha256 cellar: :any,                 sonoma:        "d0faa5d25739920faa96b0f20b952debf60d6c83a7cc61e5066ba8520307f9f3"
    sha256 cellar: :any,                 ventura:       "814f338216b026ea5c9a5738edfffe354e95830a5ec7191f3207ee8e1131cf41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "785b6d0f812f0c52b78b71e6dab72339f3c7a81f14714e9067e5bace79d43825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fc4e7b2a40cab698af60612c5b339ce3da6b4ce04d456661774cba3cccda761"
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