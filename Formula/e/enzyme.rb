class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.136.tar.gz"
  sha256 "b0e1d7704f576ed61b43bb0349991862eeca5b66f3284842e3243ea570b1013e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d1b7b14cb0c8f91e53b4dce9067ddbbc16ee8be9361da3acec2bc9f41ee8626e"
    sha256 cellar: :any,                 arm64_ventura:  "25e968fd0a4c01877c7fb9e283c74a7f52fcc13d61504951a7febd6599cdc9a3"
    sha256 cellar: :any,                 arm64_monterey: "ccdbd2b7972d8ecc0c3e4954c238e847886a86757bb62189c42b050514db56f1"
    sha256 cellar: :any,                 sonoma:         "05eb28e49df57a02467b1062ab9cf39a859e837a549b0a77c975f7f39f0f572c"
    sha256 cellar: :any,                 ventura:        "f72cdcda5fc7fe935fb09383480b49db1a2ac820f805a1a3967bdc7a9fbfc6fd"
    sha256 cellar: :any,                 monterey:       "ad0654a3ca23eb54cc3cb038e3efc7de79a92ad99f1a19bd34ac13004e282810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02f08ff083864da97fde52ecae7f8dd2a20df0c10079aa11b9bb2813421aa224"
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