class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.151.tar.gz"
  sha256 "d85628b03837b0185b5db75733b86d882bff71716627e5283bba11d46d22f424"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "247bf848c2581c7a1eebd5208854fa06f02149ac3bed14a1c93d4ccb91697198"
    sha256 cellar: :any,                 arm64_sonoma:  "0be91ef354c7d75ec2f76b53c0e79a8379c0548d5457706719676529f48f276c"
    sha256 cellar: :any,                 arm64_ventura: "a908c32d42e8e94b722a1a0c2878505fd67c5fb8df9cd1c1a1cdd5f640c57275"
    sha256 cellar: :any,                 sonoma:        "04a27b25a2e2fa93bd430e5978b385e122828ed1c56e72115da87fcfe91ef31d"
    sha256 cellar: :any,                 ventura:       "877c9f83839bec8829e5b5b0270b35ea0177fd27d7695da79cf28da1acd00a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66794e8861ccb3a53121110bcca575cdb6e2368e8a4d835e7e63a774ed6eb271"
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