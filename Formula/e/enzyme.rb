class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.227.tar.gz"
  sha256 "8dac65f59a06559541ed52f67b37e7dd76c82f6dc8cb0f8008ad55cd6b5e3a5f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a452a5d26a1f9c91f4895992cec2b4301982166a67c54dded685fc9117c82d90"
    sha256 cellar: :any,                 arm64_sequoia: "1bcdbdfbbc230ab51a9a4f990a6e69bfd4c14e5c316efc705a52bf298907cd4d"
    sha256 cellar: :any,                 arm64_sonoma:  "1d0d7022033f4927265ba6c381b1f3a393c7a3d6ffc17e20a5a9b312c429b41f"
    sha256 cellar: :any,                 sonoma:        "c6288aa6f2d92c42a11fcf3212243716268109aaaea9d306153051f3eec6e783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4471d98556932a9fb026da8eb74c7e950ea1c2ad00f20fc8e498755140caf964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae8c02aba81b8883ac86dbc76613b363b2a3f9ba3198ba1a63fbdb1bf3f3600"
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