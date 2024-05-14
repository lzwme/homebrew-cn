class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.109.tar.gz", using: :homebrew_curl
  sha256 "375e09faaa43679592641cc586c7457825cf679d4acee91239d6235d4b807e25"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3be782b9bb56205bdb18613a39daba5ca4783a25d2f73c34885ffb58828001b4"
    sha256 cellar: :any,                 arm64_ventura:  "8e2489c8a3ae2cf2235edee09a00b7112afa18027af32a8ebc6846036888228e"
    sha256 cellar: :any,                 arm64_monterey: "4c8b6e8e1ef831de2c011042dd6fd20270227554438ffafe0f13ed449d32e9cc"
    sha256 cellar: :any,                 sonoma:         "efc731f4517cd2bc8a38e2eec840bec8266042b12e6da49ee937a35fbceff3af"
    sha256 cellar: :any,                 ventura:        "d83f34581ce6b47705956e0286d061e4828b6e367e8df9e3a20d9207378c463c"
    sha256 cellar: :any,                 monterey:       "701c40842af5d4bcec86a9dfde3a872aec2149ae5772def20f23c5c8aecc7de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f508fd60622360fbd4812bfb2552f2d745a0187e30353b13918e6f4e24fab9"
  end

  depends_on "cmake" => :build
  depends_on "llvm@17"

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