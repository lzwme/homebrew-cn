class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.149.tar.gz"
  sha256 "3132d8a2de60e423895ae2a5121029700460d315285ca9a3b61157916ea181f8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a8fe291438642e5c91b1badd92f56f89146ada48a7aee25835f0d0e1dba4788e"
    sha256 cellar: :any,                 arm64_sonoma:  "0481aeb7aa47b0adf88d9f3492f8744db16a1a5efcdc3f9f502e4a4cbe2361ef"
    sha256 cellar: :any,                 arm64_ventura: "2b7f4f101d9afd6830bbf28d5a270bcd0710195c790f9c2f23d5ad4055eec6c5"
    sha256 cellar: :any,                 sonoma:        "15736481c8696e0e1571f28e6e17e5035864c1e84b1bbaccefa8ea7747143cd4"
    sha256 cellar: :any,                 ventura:       "2094e9715fc9d2e3a557e6e5480784f9fa3600621807e341560ee137b2ea82a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "914547ec6f3a7a4528a136bb9bb76bc23725aeac54d0625ba5e53e007419e9f7"
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