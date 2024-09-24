class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.150.tar.gz"
  sha256 "9a6cdfef009f86996479d8ceb63bae3341df9f4394c62509d3e8ae2e0cadac22"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0aa59cb38517ba45179d4499c36eef7dba05838762f11401563e916ca0898b05"
    sha256 cellar: :any,                 arm64_sonoma:  "1a229bc43778b80cf011626b7423b33e56553a8c51c419467533e1da3013aef5"
    sha256 cellar: :any,                 arm64_ventura: "36cb7c3acedded961f6ad650f568582b996d8acfe7ec7dedcdd30542c3dad7d0"
    sha256 cellar: :any,                 sonoma:        "322ca2de57cdabf40610c4ed94efa473a42d8ea827f595dd5fa7c9c59538486d"
    sha256 cellar: :any,                 ventura:       "9557b8185c83f3c18eae1146a3400896c029b17a118f8c0f55ac49c6b17d104a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a235a0d2067b4d833b702e45bef7a9344cf4bebca05109eca8e5e11af5672aaa"
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