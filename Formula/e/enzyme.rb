class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.139.tar.gz"
  sha256 "99bb859dd5c9a978f239120d671162c6128037534d936eac5e16a052d8421e73"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "27e8f9efec465ba91f8e85dee0b85ef04a66a9e419bc283688e7166a0843830d"
    sha256 cellar: :any,                 arm64_ventura:  "8f9d35a3597e560ff0d74d66ef6744985a9cd901e193f4012fc81623e7ce0714"
    sha256 cellar: :any,                 arm64_monterey: "7e78fb3d726fcf7c3077fd4ec72be3219a0d54fd1628c554619883af0e020e80"
    sha256 cellar: :any,                 sonoma:         "667fa3baae086972d63c777e3e71a42f243dc245e3166d59ddab6368d28e3bf3"
    sha256 cellar: :any,                 ventura:        "9b9962a7d584993e1575de6e5d034d189a4d550e6efa667b40f511944a0b50c1"
    sha256 cellar: :any,                 monterey:       "4d6a631d5241fd69edb670c04bd29db849fb085dbf3e104425b72f0c98143619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1b353c36698b3693f2843b7c275d4a8269b2339fdad3c02747c19c68bc6c9f0"
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