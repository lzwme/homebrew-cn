class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.92.tar.gz", using: :homebrew_curl
  sha256 "8cb6e53211d8719726600478d76be4a7f863918d6946cdc1b6d385db93fc4f00"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9dcecccbeea5c2b36e34d3ab3c40ba9e10389c2ebc7b1cff96a95dbb4b29643c"
    sha256 cellar: :any,                 arm64_ventura:  "0d1a90c44cd951c49ed3ce365a6d92729dda6e33f012c0036d1690b8f121358e"
    sha256 cellar: :any,                 arm64_monterey: "a3f3628ee6c131ea07f65bce95a8c8f44b86820e2ba3c2fd34d4f30384bcf92d"
    sha256 cellar: :any,                 sonoma:         "4f8309690ba7b3eb66d412fcd4e36667d4cc0ca3bad291bd53ffbbf20f505e3b"
    sha256 cellar: :any,                 ventura:        "2f2f33e21e6fab6fad0650b688980f4caedec651ca1cc068eb94657ac8c0a66e"
    sha256 cellar: :any,                 monterey:       "253b2f7ebc2b8495899a45519a717fcebd4c57779fb2e58635787b923122f842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc8e4824de483de4e872f4bc8d5ff66ef7d617fb2a994a5d43cc108a6123c838"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end