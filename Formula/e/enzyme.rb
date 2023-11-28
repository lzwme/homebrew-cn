class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.95.tar.gz", using: :homebrew_curl
  sha256 "7dbca2dc195514a53447abb8942aaa321ef9d4125e5e9c1d5607ef13d50ed7d8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "906e94867143e33de93f9b7c494222d141012899a550a68166ba27ee56619bc5"
    sha256 cellar: :any,                 arm64_ventura:  "4fd546694ebd99ff538f6c4cbff20aebe54092dd4135d049164ce01cd0913d2b"
    sha256 cellar: :any,                 arm64_monterey: "883b91c7c27d1e324d1af9312e6606df9fb186183d573086689ad55bf34a7aa1"
    sha256 cellar: :any,                 sonoma:         "3e314005e99867930af1b82d700a66d4e4bf7cb36f2802de60b373eb2f441d06"
    sha256 cellar: :any,                 ventura:        "873741653d5309a9047858d95ec6f57e94380ef50c09ed45dc9abd56538f1a02"
    sha256 cellar: :any,                 monterey:       "cc182e62ad17c3f9934ea7a7f4188b1d8b3c25a8a7eb309b676af6c3ca4174e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94eb97697b1b782bb57ba420a7d73764822edceccc954b7431702e8317cced33"
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