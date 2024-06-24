class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.126.tar.gz"
  sha256 "2c5929580959eb3f6959934aedade4b257f11d67daf4280847882bafd821ad6f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0523109bfaf52cb7ab4a9caebec19adbc68076b60bfcada83ba23d783ad38490"
    sha256 cellar: :any,                 arm64_ventura:  "6f3720ee638b8adff8694f162d5b138fc7a446a7328f01106b51d160dcb867ce"
    sha256 cellar: :any,                 arm64_monterey: "77b7a960e9abb12683a85a4447be9a59c0f2c71f22d4e9a72228bcb791da837c"
    sha256 cellar: :any,                 sonoma:         "164597f7e880dcc47f6fb9b57e898353fc6b14eef1ab37e58e78b76b244701f8"
    sha256 cellar: :any,                 ventura:        "46dc056744a4259582ad2f0890867c9daceec5cc7dbd6632d575669ecc2cd0a0"
    sha256 cellar: :any,                 monterey:       "e231e76d04e453ad50657fdcbd06cac5fcb5eb571436b8084fc5651012c9db94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a366d28921ed3f1635233481b8e8e0159da771b6f879b09517dc3ea8b0091af"
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