class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.261.tar.gz"
  sha256 "d0478002f68e9375435320bcc03062439491c640e63dd4088ec4fc27f1c1e199"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f22a4af8d0679ac39f608270a0ee1df04a81edb8f085bd4227df3e3c7f663d1b"
    sha256 cellar: :any,                 arm64_sequoia: "b28b351b8a220cdbfcde9e756c69dee9c8809de1061809feb8cd5db3a50c617a"
    sha256 cellar: :any,                 arm64_sonoma:  "050cef8bc21504c90eb15f2330c930aefe9a84a718ec89fdd96741e1b90d90ca"
    sha256 cellar: :any,                 sonoma:        "d0afc1444a63862afc82032b96d5e92dfac582fed3aee5a25f9822e7974b9512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00104cc5ede6057145a6f81db0bfebece295c09c632936dcdce245c477aeb3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94aeeea58866e939e59fde8ebfc40c5b9328963b4cbeb3e71f1ea9035efdfe66"
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