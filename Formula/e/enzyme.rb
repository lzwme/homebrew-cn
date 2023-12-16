class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.97.tar.gz", using: :homebrew_curl
  sha256 "5906ada23a039b66f4f55bc5dce3ac6c6d3a2ed58255237a4c551dd0b9b5eb60"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "49acf9e6f3cf8e6fdfa0100c6e2bcc12ff65340939e00add2744de455808e616"
    sha256 cellar: :any,                 arm64_ventura:  "c42fb8203343994162ffec3844eb7b5ba99cd91dce69e979126332754c29c09e"
    sha256 cellar: :any,                 arm64_monterey: "eb790fd648c7ca7c8208cc7d8255f34d0a9cfea46b985482bcda82054da55e3d"
    sha256 cellar: :any,                 sonoma:         "6e8ec0c2c41c609c3b4c184ceb19695ce181c9a7d96537e26900dbacdaaad3d8"
    sha256 cellar: :any,                 ventura:        "3f93693724c9276d455593f7e5f48819eee58c0364b98bc7a4beed6b5dc4378e"
    sha256 cellar: :any,                 monterey:       "852181bac89fe72b6df2992447930a97723b34fbfd5522dab66f2612c6830ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dff9bccfce783a15e3f1bfdcaa5902da566b5db967bf267d808d71769d3b848a"
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