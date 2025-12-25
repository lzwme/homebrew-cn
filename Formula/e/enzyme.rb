class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.231.tar.gz"
  sha256 "500e7d2d8179a41f3ebb39037c83da88ce1fd68c830a30588a82d63c445dce99"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c8a51d33e27164e379d91fce04a7efb77b11204c12a5d066d7401550eb638d02"
    sha256 cellar: :any,                 arm64_sequoia: "4a3a8554e33814f56371a036d039783f25c3e9c9be0a5aad924c243d41b34280"
    sha256 cellar: :any,                 arm64_sonoma:  "3c49d832a7659c36f872999dc5890daa88078c1e877d5d90e774359fecd484ea"
    sha256 cellar: :any,                 sonoma:        "56efb36df0a36081c4c8d73bc6102ed3c46f0c1871d336f29d86ccac51325b1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97d64f1425674830a67ac7be4670db1e9cc2f6a1ffc2099d1e90f0bfe1e4f4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "408de924b1e780a37d93d0ccd45c2386d22bcc388655cdcca2d1b2c0347a6325"
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