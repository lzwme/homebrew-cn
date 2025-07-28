class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.187.tar.gz"
  sha256 "44bdbfec2a2ec640f39244f92f36dee9b9b383559d8065138f72c9c612bcb5fc"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "01df61b915dba2523be5906e0f58e835fdf8a3cd9a69989414b1f28b55a5fbc4"
    sha256 cellar: :any,                 arm64_sonoma:  "5fe2238d7880f205bcd4960ca1ea1858998395d6f1ff13d5d5d5ece4f962a424"
    sha256 cellar: :any,                 arm64_ventura: "8a3685433b9c9ef6e59fdfa1128084230482b528e8a598e37621ca9d3789019a"
    sha256 cellar: :any,                 sonoma:        "f4074eb8f5b1f03606e1d89c30df96ce3ee320a038f52224eaa629321df2ba7e"
    sha256 cellar: :any,                 ventura:       "203d317ea2a8e70a36eb915b77c47cdfbed721bf0d8347b3cf7687380b054ff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3356c6d159c0ba3c573a092b66b6d3855320b1607fa82640692ff9148ad5eeb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b030c741c3a450b300e276ded7d08ba09a80668c301bcb2c0d849efc0feb561f"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

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