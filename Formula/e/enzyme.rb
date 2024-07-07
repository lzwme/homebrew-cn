class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.131.tar.gz"
  sha256 "b353fd6753079729007a075ac503b7b7ed25879ac64b699eda053a4782e12510"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2467d9c171581f403d21f4ee54d558b77a8d27861b3114ecd4e3a31593c40634"
    sha256 cellar: :any,                 arm64_ventura:  "b6d92532f82addec5d66381563b710640c279479759c69d9b8edc8cbda6eb7ef"
    sha256 cellar: :any,                 arm64_monterey: "de6c56a94e39a2f7e209ee15e4ca28bf3a52ac5edd3a38ed81a1e97c31428edc"
    sha256 cellar: :any,                 sonoma:         "ebecb13692cd377c99b6e95de19ddf9387a58131bace4334dee72c8f7750bd4e"
    sha256 cellar: :any,                 ventura:        "df202020d13df377ab4bf28ccc5a0e22f86a754212de334be38824303aecdedf"
    sha256 cellar: :any,                 monterey:       "dbff826963c9206d5d6cc0b9856d56fe1658a590baef21f2a343a08fde6125cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb035eef02c56ca363daa2a898c7f6ba3b6ea92e4b30523209c468c301cf43df"
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