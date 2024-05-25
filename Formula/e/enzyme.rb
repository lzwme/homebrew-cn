class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.115.tar.gz", using: :homebrew_curl
  sha256 "2f8af33cecf6be1abbaeaea2e7a226da41aba11d2a8394d2b680098d4928cd03"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98aa5ec7503c1dcd0b2a9767d371e822bd2289eeebc3bc459f8510cf7cd20606"
    sha256 cellar: :any,                 arm64_ventura:  "47e8d2f05000fd3894d82ac022b9b95b27843ca4851aa5cb6e531765c7eaa234"
    sha256 cellar: :any,                 arm64_monterey: "1c1c6786fcf80c868bb467aeba68f373ff276b22cf65ceb2ce727b538656fefe"
    sha256 cellar: :any,                 sonoma:         "fe0fc31f18fe72cce91f144c29a30f6836294fbbf5590c267096187481209849"
    sha256 cellar: :any,                 ventura:        "bede74de409f0b1ee1646588337e12fa2ec88700583adb2b1cee7c57beea8f71"
    sha256 cellar: :any,                 monterey:       "539014b2495c17eaaa892dc819882a1b2ad5e53e0e2e4e3e14f0e72e9bf8d4cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce950875ae26b5b4051438f6f7c1ea5ba33c5ec86fe71eb59ce3c03b630fa8f"
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