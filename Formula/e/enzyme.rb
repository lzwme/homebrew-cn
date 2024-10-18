class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.154.tar.gz"
  sha256 "51a372309f1cafea5bb870327a69d823c3294358dcff1fe7969c5b68b3e70536"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "24f7aaa625233f430a1341c15ca942457d4d974da20b1966e3d8d4798d62e826"
    sha256 cellar: :any,                 arm64_sonoma:  "ea37f50fe95304d339e08db466500a2af96a30a12415aaa36ad927dc77ddfa90"
    sha256 cellar: :any,                 arm64_ventura: "56bbc803453e2c896438662c44efb7f26e29b396c0bc45641865a70271aed83d"
    sha256 cellar: :any,                 sonoma:        "f7d884bd63883dc198330caee8dcdc9c69f03e7b6fc4e65744757bb7b30c0da9"
    sha256 cellar: :any,                 ventura:       "8894f42e4ece4c4d4e88ebc1887457e2e9d22bc4b32b65e5f0401a1e3391fad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "508589a33af7da1f7f5a8feff0f52e0a709176870b8b52a4bf7af166266f8bdc"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}cmakellvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
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

    ENV["CC"] = llvm.opt_bin"clang"

    system ENV.cc, testpath"test.c",
                        "-fplugin=#{libshared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output(".test")
  end
end