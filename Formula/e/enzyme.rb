class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.119.tar.gz", using: :homebrew_curl
  sha256 "2d9af4df3164c24aa701e1b741fc3945eab12554464c26a6fb22a169a5599c55"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef4e73beb47af125c2349022d417e372e4e2a99ccab921829368f8f0db9d7b73"
    sha256 cellar: :any,                 arm64_ventura:  "97d7dedceda5125c8a3432954db3f6389a46ff271310400b028bde15dad5c15f"
    sha256 cellar: :any,                 arm64_monterey: "5bfd174fea6175602114f952e1359237d374a6fc08947754b2d4bbfdeb364cd8"
    sha256 cellar: :any,                 sonoma:         "bb3128eb28b90626265e50b322018ef70aeb80bd97004c56563f5ab459b88209"
    sha256 cellar: :any,                 ventura:        "36f9a29e350f7cf8579d01fb076aba54bf1b3743c1bb711d01437ff51b0bda2e"
    sha256 cellar: :any,                 monterey:       "f345bcf5a5e6d809ed4455096bb37351994892ba9793ea4732223cd245d748f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1841b8c1aa88a467edad2298ba2af15f94043b6dc49dd13f0637c6181a3aed5a"
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