class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.118.tar.gz", using: :homebrew_curl
  sha256 "4590701cd61c750f191fe64a052812c18ce510ec91ca0d597adb2dd034c1d33f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d82bb3766364573db62fca45e6d6ee0333c871adca37b893b45eb9f3a885329"
    sha256 cellar: :any,                 arm64_ventura:  "d70e367055c31884486201142448c0cebce1620746e596433222d7431287dac0"
    sha256 cellar: :any,                 arm64_monterey: "ea210796471b0d6baacede28c4d8b055fb2e48bc9493404b289ddea7f025ebad"
    sha256 cellar: :any,                 sonoma:         "05ce73ddcaf0b1b9236e9a6e728867f56bcc46002fa175bc2848d3368293a106"
    sha256 cellar: :any,                 ventura:        "906459ef23fc4c5d55ac080a6390c61c5f9d63fdd914b9fb6124d531dc74eb51"
    sha256 cellar: :any,                 monterey:       "916c1a11b1f994ecd350a8690f25cc3edd1b656e67abcf3b505a2b903632347c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "861f7bc4d47281de03f615c069dbbd6238c44e276e0f6de35303cdaa98ab399c"
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