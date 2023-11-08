class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.91.tar.gz", using: :homebrew_curl
  sha256 "44dee4bf70e891da5ed9d7c7ee0e43b70e79873c7b07775f6c2a060dacf13a21"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b4ca796a5c8e7433f7787a63080f98966367d1850df940053d849e819d6ed5f7"
    sha256 cellar: :any,                 arm64_ventura:  "c8871ee99ca557b24b10b68fb295591d4e42b9b88359e4e6aec4516b40ce1062"
    sha256 cellar: :any,                 arm64_monterey: "294af957899826350077a4a5baf6767082d732201751aad2959526cd1a2262af"
    sha256 cellar: :any,                 sonoma:         "cb97702826607e0ba1c44e33205ce9d122f51aa936ac3019d44af5b609820d04"
    sha256 cellar: :any,                 ventura:        "7195673303d3b2ca518de8c9c59a1fa39c7f137c15a31cce694ad58655ad84aa"
    sha256 cellar: :any,                 monterey:       "876421f4408e183c7e7729fec12c3cc03b3a8c943cc9f5296d88b08b8fe863b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f6937a29a58cfc6ec2618a097603c1a6523ae37645124177c86853d5a47842c"
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