class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.124.tar.gz"
  sha256 "2a119c33c714cbb5d2a86384823721c9b35b8b240bb29141e84d7a53f926b93f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ee4309f25ce9ff1f8fbdd834df3e3cb00bc6be62a3f9dafbb63d469ff6e43ffe"
    sha256 cellar: :any,                 arm64_ventura:  "8663b9ffed37ee90d27d36e82a722b15fcf26f4b390137829c825f263af360b4"
    sha256 cellar: :any,                 arm64_monterey: "b27a877c5551520ef54bf16cee1deb0acc814ce9ab7ffebb805562d202d3ace0"
    sha256 cellar: :any,                 sonoma:         "709407b5a8db470e564bee9d13404d206bdd33694bc047ee01512f8b7c7c5f4b"
    sha256 cellar: :any,                 ventura:        "1bcf208a4229e2974835a4dd6f1e632b5ada510e135fcefb72a39a080afcf347"
    sha256 cellar: :any,                 monterey:       "39611057bb0e2f89e21b8de7ebfc1c12d7ca865bf07eadb9ee07893b4cf00fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22bfad3c5804415312c16e2603b07795eaff6718caf711cb58cf2e20325a5050"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}cmakellvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
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

    ENV["CC"] = llvm.opt_bin"clang"

    system ENV.cc, testpath"test.c",
                        "-fplugin=#{libshared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output(".test")
  end
end