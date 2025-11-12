class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.213.tar.gz"
  sha256 "8861b8dd235724b389d3c6a3542dc2be81eef3db00d7d2bb2c72f3f3b350687e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eaf1ecafa7647fc5b86d3bafe957c198a98f8d93dd6c159a3dfb17d9d95ef1d9"
    sha256 cellar: :any,                 arm64_sequoia: "6c2eb20ab5fdb169d9e9120e680ff4fffcfd01f93ffe6ff46d5c3fb402f2b11f"
    sha256 cellar: :any,                 arm64_sonoma:  "e4a35570d5205ab6ea9aa529151a8879ed44fd05896b68ac25b04653d85cb7c9"
    sha256 cellar: :any,                 sonoma:        "c74f3f599e4f7c8f3887f8e383f22f3ec52db0e1a8e42e405eacb6e6b77a8ea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c38c62298283de29e3435f7c97308fd756f38e66f008749bfe83272445b03ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8464f8944120d67604355f21ae3a2e7ee03891c4e33c2a31b5a20e60f28fe82"
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