class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.249.tar.gz"
  sha256 "0842c14bd3953502bda6e8bdff22e94f3d49b042839f2ae5c3d502a7686ab969"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c70941d1aa03eba0bd23b1023338b31f5fc41cbaee2d916be3273818c8b5b15"
    sha256 cellar: :any,                 arm64_sequoia: "c459a1f0413fdb0f5d0af21f2df6be756dd792bd15680dab9326d2519569e1c4"
    sha256 cellar: :any,                 arm64_sonoma:  "e82722cb35e92f77eafcf4166a34ef8c833d3e9f2ebef32dec2d856c097305e8"
    sha256 cellar: :any,                 sonoma:        "cd3253f2ae95f21edcf479592a33cfe4ab9577c1f86859de4da3240966306ad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bee47e733bd4fe5a87335cdca295f0858b6bd1af4ba24e06c807b2fb07658c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7227e6a02c56eb2a91d7779e82db1fef6f0847a64c744904c1087d01514dfa4"
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end