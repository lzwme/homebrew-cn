class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.129.tar.gz"
  sha256 "4aaa693e4c808ac98a6a9731e91d452e9c85ccef301ff020e6d4a13d10486e53"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6dcabcaf7e08e075bd0dd449e425247f7e5877cb0905949f372244de9764c20"
    sha256 cellar: :any,                 arm64_ventura:  "3a5b988f521e5f01a63c672c5ae40d01660fea492b32e15a808cb6dba968f6f6"
    sha256 cellar: :any,                 arm64_monterey: "2179154670dd899879d7e1b07ba9bc51303b3ae63447c6411da7cffb2aece076"
    sha256 cellar: :any,                 sonoma:         "0aad6ee9c5cb93b22259bba60b009776adb780e56bb6ce4b6b7acfa3535eae18"
    sha256 cellar: :any,                 ventura:        "f29d1a2eb1ea1aa9781ba961548f4ddae4da42e017e0ace3ae53ea04a8658c36"
    sha256 cellar: :any,                 monterey:       "88e0d148b67a25ef2252867b423ae76ed035c3b0807db5f5ff2b3b69ac39234b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7511a810e5243c09f6f872c361ef99dd9a56a6dbb6091dff4dcef79b71660170"
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