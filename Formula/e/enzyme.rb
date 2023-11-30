class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.96.tar.gz", using: :homebrew_curl
  sha256 "b54b9e1a957616b097388494a01e8bf5ebdbf80d2fb470918a20d69f4a93d696"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e34aaed65632bfcb5d5be7879df88796931fda8a94426663dced80175ad33906"
    sha256 cellar: :any,                 arm64_ventura:  "64f77eca4616f5720a323f5a5e3727924595d72acf7b8137bcd7ff0ac794de9c"
    sha256 cellar: :any,                 arm64_monterey: "553934dbe70ce2cf85a30035017f2a4a0b75e7ee0cc9c48b0c78b46ae3503185"
    sha256 cellar: :any,                 sonoma:         "b3bc8f0abc633e739d326187e1e7f11add33b1e5dfd393a42011d6b1ad18ac84"
    sha256 cellar: :any,                 ventura:        "fd2e2ad7a261f0d1936c7552dded1a32cb02490893d3037ff09a7223338f1f4f"
    sha256 cellar: :any,                 monterey:       "cde0e4ac5bee95e499479e927295b2df5906511e064f4139c6fb909a563096c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9954860f9546463bb647431a37b6a80993425139c610f05564f5f593b29537c"
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