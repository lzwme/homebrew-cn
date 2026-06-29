class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.277.tar.gz"
  sha256 "91d2f884e69ca9db6750830ec7e6d6ffa04e8b755bb53fd71c150c4e469a74b6"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f801deeaf9b533aeb3964595b0b0562ba3291b8674095ff8625d091b570cd6a3"
    sha256 cellar: :any, arm64_sequoia: "f805fb2915aa96b86353d6460f3990967d0a458da9d5f401ed7c4722fb5c3189"
    sha256 cellar: :any, arm64_sonoma:  "cef774715e44bdcfb0df15cf4f482e63029cce65555350a2c0a381d6d9639c6b"
    sha256 cellar: :any, sonoma:        "1d319a991b1c7f7fdf0866c8e12a4a7b0129531d40d7fdc6b89f4df80c869e39"
    sha256 cellar: :any, arm64_linux:   "35e3729ef799031e3c7c6bd41eb9292e927e5a9f8b90eff9e2eb8d2a92e7451b"
    sha256 cellar: :any, x86_64_linux:  "bfc18fa11907165370d443c5dc31679be545316d36faed4fc10a6a2390249e05"
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