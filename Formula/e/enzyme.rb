class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.138.tar.gz"
  sha256 "122ab869497225bb46001b9d2e5082d1c4f1890a2236fac32d0d05e340e5381a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2e0e95f259ffea5acf569517acbd24174b44dd19d4917a26096e7d342eb4ce97"
    sha256 cellar: :any,                 arm64_ventura:  "2cf45b4cfef536e242ef9b8c3dfd8f702ef5aef28c6ec9f8e479425164a71a67"
    sha256 cellar: :any,                 arm64_monterey: "9712348b7d1f001a54aedefbca1d7501f53529d2592d06b396c7c34b6c9aef91"
    sha256 cellar: :any,                 sonoma:         "36da4bf13826b9246450435850608280fae80d3b5691ded21f6b7690069cafd2"
    sha256 cellar: :any,                 ventura:        "ffefa23c87cea08901d29b612f57e3d5b56ef93b2d42b6ecd993976af87c7bf5"
    sha256 cellar: :any,                 monterey:       "75cf520cefdf2aac22b2631501394c8009d4a142da750458b75b0eb9ecd4393c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cfb9c31c6fcac1dc624289ccb4460e68f7be48125ed351557bb35235d6c9d25"
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