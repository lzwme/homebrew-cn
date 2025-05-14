class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.179.tar.gz"
  sha256 "738e2277aadb67733b4546b7abcade212452bec97e67db9620a7840fa70270da"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12116cd5762d226b096c23cb278fbbf498aead3bf7bf95fb44160fa738767913"
    sha256 cellar: :any,                 arm64_sonoma:  "a8f7414fee54812dbd8919e9523481dff950817aa1687d1c9f3fdaed77b025a0"
    sha256 cellar: :any,                 arm64_ventura: "94b4d4615a0c1f4c4869e07b3ded647bed9e4fe4fccac13415109c5c4fe5d7d6"
    sha256 cellar: :any,                 sonoma:        "7d847c13b9d59b715dfb075d893efc99ffb14591d687cf7f916b4502f359b453"
    sha256 cellar: :any,                 ventura:       "b291ca735ac5d83b2605a2d9eddb1eeaf40600d50f9068dbea798c702a5afce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "571b49b3182fd114eecc013ec6e084e77411fadebd85e1d932ea0707428f88c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef2cad3fa15b9a951683ffdadfed0dedfcd197f9ef8c8e435d5f54ff7066b48"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}cmakellvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
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

    ENV["CC"] = llvm.opt_bin"clang"

    system ENV.cc, testpath"test.c",
                        "-fplugin=#{libshared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output(".test")
  end
end