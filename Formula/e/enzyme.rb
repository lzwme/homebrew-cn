class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.90.tar.gz", using: :homebrew_curl
  sha256 "cbee9fd802aaedff474bad8fe4df3b8b55206ce247d5ec6a0de356f952f7724d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8ed9b96b5454ddac37dac31f26348f4b05e1157c63ecab929e4a4915ab8a5b2"
    sha256 cellar: :any,                 arm64_ventura:  "9cf20533d5c413b9f410ac9796e4fb7f669d57a914b2a07cc47f50b1eeea5e33"
    sha256 cellar: :any,                 arm64_monterey: "42c9f8553242386a2e2e02b436da4f0df1327519960902f017bf4d15f7c92922"
    sha256 cellar: :any,                 sonoma:         "abe60bf9f02093df0d0ca50a51ebda976bd63036b71b03e8a2bed1ec02c3f5ec"
    sha256 cellar: :any,                 ventura:        "84496fe5c8072f1a0d630fc65ff7d439d6161057ea2ffa8fc6003dc394543aa1"
    sha256 cellar: :any,                 monterey:       "ecf7136df46a4d797c1a1bdfcbd55bd6042f54cdffeb1e6342d7cb5aae4c1908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dda8bb622c7333d7dd156d57e55f7572a4903187eb269a8ebccf8a2f972c8d5"
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