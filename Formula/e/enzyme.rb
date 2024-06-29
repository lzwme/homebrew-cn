class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.128.tar.gz"
  sha256 "759a3b0ab598df65416c1019e2797ea42cdaa3e766d19d19a476f317d2497c82"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d868e576dd8c4227b955e1c5c1a7b43e5dd59b82fea481368ce5de7e0e44005"
    sha256 cellar: :any,                 arm64_ventura:  "e6bbda13a2cfef8f074a1183e962d9b082219ac09bd157a330c4f19d1012d723"
    sha256 cellar: :any,                 arm64_monterey: "dd31945f647e055ee1d573606efaf52916b60fb8f747c55c9218f8766ccf7283"
    sha256 cellar: :any,                 sonoma:         "f864ea2be042f9c766fdf6aa3c56c54db9e85cf0ec160c87d45e5ef0d2e455f4"
    sha256 cellar: :any,                 ventura:        "85213a888898957c6dbd1f24b5093b28d42b4fc04b3f56037890f318488c50d4"
    sha256 cellar: :any,                 monterey:       "9cae96840109d66b92359f98fcc55496c7699d69e4083f6b09c0cfe6298f5f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d751355da80922442ef2e6a6bb200dc48c65dfa00739dc051afaac1812bed87"
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