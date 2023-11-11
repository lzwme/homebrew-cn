class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.93.tar.gz", using: :homebrew_curl
  sha256 "749071577180df4dd30f97ef550b82dc5bbcf54907422fce4270f6e04ff7eba0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ac7af58597a8a9a946df570047d54c09e69c90e5a38485d2c5367476c1d6c8cd"
    sha256 cellar: :any,                 arm64_ventura:  "d0aaac634380de49e10b28057e6b477728d39a128a9153bc05ace6a35bec460f"
    sha256 cellar: :any,                 arm64_monterey: "791e7a0befc83682f1b10937f3e367f63ead3b4af4980ca6c8cfe025c2574d36"
    sha256 cellar: :any,                 sonoma:         "3f667cb687ccd73b6465a7b17fc1830d40a8f2043be1e118bbdce397fbf6658a"
    sha256 cellar: :any,                 ventura:        "cccac18de6515fc5ae233a2399146d876d7c875e4d8c87f4394b39d228e349fd"
    sha256 cellar: :any,                 monterey:       "8f12eb0cef3de6eb3f6c832a80dfc9fed10e8559891d8177fecafb305821aad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "478aa476298b648984c563201c4fa0544a0beaedffb5b6f81d95f7c5f5a781d9"
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