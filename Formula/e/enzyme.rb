class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.271.tar.gz"
  sha256 "0e55279bcf5306177bf1032441f1e4d3635bfff8eb84eda04225b1674e1d8a79"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dd15fff59823d5310b943fc37673e0f7bbe036a09c388574fc971b7511995de6"
    sha256 cellar: :any, arm64_sequoia: "e235c3fbaf853694eef5f6fde8c4eafe996f7a88b26c7e7fbe07476f95abfdea"
    sha256 cellar: :any, arm64_sonoma:  "a8b8cf9e8659cecb54e6a3b88db7629ff2920e958bc18aec4c6463792db4dc30"
    sha256 cellar: :any, sonoma:        "afc43e0bd129b8851daca6944adf8db3f837f5a4b8109e4287e8044f743555fd"
    sha256 cellar: :any, arm64_linux:   "b1a58480d8f220eb8087366135d7ffad41a861a2b6d4a6ec2210b9684e758659"
    sha256 cellar: :any, x86_64_linux:  "8b78ee348f409ed35107fa10d23de88193f5a57c7463d18a45afff6b912a51dc"
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