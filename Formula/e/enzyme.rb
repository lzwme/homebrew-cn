class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.141.tar.gz"
  sha256 "b25748f6ff8060fc85cf41e4cd82ca5d53acf8b9f860efc12a2876dbb69e3558"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59ffc606c1af69bf2ba8f54e3aaf1f91846f4278552d7abb6aa0d6d517a25b2e"
    sha256 cellar: :any,                 arm64_ventura:  "455a60ca165c2a073604b35c9b1517268b72e919aa08b2c98d81e19acc59e880"
    sha256 cellar: :any,                 arm64_monterey: "84aa126aaa348ea3a5e1a8da71437098a163594d50b0c80384208baf58eee7ea"
    sha256 cellar: :any,                 sonoma:         "3f385528638ba129c9b334b579c2da5fb32419bf14892809fc75211bce78093a"
    sha256 cellar: :any,                 ventura:        "b193c610d11154d218aef8234143c1fa06930474a5436f2561f1ac5087a861ad"
    sha256 cellar: :any,                 monterey:       "c7017585491d308539f38a019da52c692b1c901ab828d5a44193961f51ff19ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abcf8ecf9d65903a8f68fce55b904812c68e1e70784de713dc89a3a05bfba5f"
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