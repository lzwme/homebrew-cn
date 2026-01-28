class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.242.tar.gz"
  sha256 "9f0e4da796a309a8f90e25db638ca6d293563cbf87e1e184e33057dc015808f6"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13ba0e28bc7966ad962120e61eee6fb45363fd043fe81a09f32a7a275852b49b"
    sha256 cellar: :any,                 arm64_sequoia: "e074c0bbf5a476f26760fa69327d6ddbe144289570820827113165509365845c"
    sha256 cellar: :any,                 arm64_sonoma:  "540ed6594c1b0f6d6b76dc4277116a4f51202bda7c716ae61cd11ad10ddec707"
    sha256 cellar: :any,                 sonoma:        "b9a4ca7572c314abb8f436c2cda0bea298ed23d911d7429e128f3ce05bde31c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4e948c76c60935a71634e6b223a20f5fc726f233d4cb81c2cc810173e55be23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c036f0fea6b165c0459e09855b74caf5d59a1533b1fb0ef46d4af2d20d16f4dd"
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