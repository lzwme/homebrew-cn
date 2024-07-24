class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.137.tar.gz"
  sha256 "ca77e74844db8bace823f22f22e5308885bddde49887ab0923c23268ab6e68bc"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "631b4e3de2626a2fcd43621b92ee1a254b49c3aa4fb2c2fb89764deb3b84f32b"
    sha256 cellar: :any,                 arm64_ventura:  "614ab6283fe285777fa9ed3bc3ac45442d969ab6181b1e012d85a57b160c0bfa"
    sha256 cellar: :any,                 arm64_monterey: "f1904fcad9627dd394b223b62f8c4121c5d3fba2b1c0e38a8627094910880d33"
    sha256 cellar: :any,                 sonoma:         "343c33ee1206b574d88706353bc8327c38b31e379c702d4b259ba2f32f9bc378"
    sha256 cellar: :any,                 ventura:        "6d6eba7afebd6f54074a243c51706b71faf5ba34741abf641daed17da0a4fb6f"
    sha256 cellar: :any,                 monterey:       "624aac2ce27eaafeb29fe82578cfb5ded5e79e2d2d2a950056e820c57cc4fa1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "553dd4f17373dc3ede8af5704818b4015c9deb9553cc0f4174c1274880454778"
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