class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.163.tar.gz"
  sha256 "aebc4091fb6a2dd037276a5318047498656a753d34f69b8c58ce87457d0eeaf8"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b13689d0a2b32e475fd9cd5e6c01262e3c6bc509720382e6f6ee276fce5853f"
    sha256 cellar: :any,                 arm64_sonoma:  "4d3a40bf1efbc0c42c10ab3e1e6d4b7e0c719e7f8f965965f18be904bc101947"
    sha256 cellar: :any,                 arm64_ventura: "f6dd0f1e8bbdba7651e8367d029041c615c53c216baaddd5f626302367a5a082"
    sha256 cellar: :any,                 sonoma:        "cf787e6508e679098b8ba15a9286b1fd5f97eb6539868fcdfb146509c6e72339"
    sha256 cellar: :any,                 ventura:       "3ac8bb5d8176c9ed191b3c83cf3bdde4cfd9364f9b330f7f7dea0225533915a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31be3f3d6b7e2641d2f060ed039790b0e0bf04b1ec8a0f7d4b5a0713b7cd6475"
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
    (testpath"test.c").write <<~C
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

    ENV["CC"] = llvm.opt_bin"clang"

    system ENV.cc, testpath"test.c",
                        "-fplugin=#{libshared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output(".test")
  end
end