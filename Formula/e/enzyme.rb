class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.148.tar.gz"
  sha256 "914eb6e0f9b44278655f3ce02dab8d04b9cd780796917f9cbc4a6e2e56e4c9e3"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "01e3f6c857f4f28ab0c338eb596a3dd25f4d71db02faaf99a3a58fe7c0bf9f90"
    sha256 cellar: :any,                 arm64_sonoma:   "4acc1ec132d5344b1a2fd5846d67616529dc1420b8957e52f387c87c4af3f31a"
    sha256 cellar: :any,                 arm64_ventura:  "02737a76fa224cff38dffcf9e4bdab1e13da22dcba1994b3f99306cf497c697e"
    sha256 cellar: :any,                 arm64_monterey: "bcd9b320147a574d0dbc6fb341fc4bd19bac77c2c0fa2f1aad67ec50ef22635e"
    sha256 cellar: :any,                 sonoma:         "ab667829fa40dc9929f625276fb8bb5e819270c6a4d2663d38a605c57b75d72c"
    sha256 cellar: :any,                 ventura:        "ea83001c8a2af51e6ea0fd87d45ddce2618816ebeb33674b35231bbac33c5169"
    sha256 cellar: :any,                 monterey:       "707b613ebb8dbd346bde0bc983d43d4b4bb56047b431a198e7d2a2f0a0c63e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa8bd873fdc0ecc513a29147e3db73d5406627cd2587000eaf6b34d6867f6997"
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