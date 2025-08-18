class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.190.tar.gz"
  sha256 "a527350cb94b33ca67a8f9f55275a120495acd474473250727ef7fbeb13839b9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "820f2e00b715ea57bec4b1ad38d8369666c3440828100370f31583ffeeac77d0"
    sha256 cellar: :any,                 arm64_sonoma:  "d975b4f49ab9bf95ecb56531d44368ad72d1a4d23474a63ad6d91a86f75f53de"
    sha256 cellar: :any,                 arm64_ventura: "d382ea69becb2219090e5d55424cb99b54c7f5fdb394416f20b30f487af16232"
    sha256 cellar: :any,                 sonoma:        "c96cc6f7f2e88db108da7a3cd505991ff0969666d98721ba88bc295f8ae60b80"
    sha256 cellar: :any,                 ventura:       "77dcd6c2e1d2093b3aa2a6b8c1a0d9dcd172642ff0a4b30e28988bb332f8c23d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fe33512657b7863de2b10e1ad64426160a9cef710d96eccd05a6409f8a9bf14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "202d520ed711bdb874a1d261153cf865cfea6b8e23b75856b866b5b3a3d56a6d"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end