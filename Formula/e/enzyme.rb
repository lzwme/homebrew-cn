class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.100.tar.gz", using: :homebrew_curl
  sha256 "fbc53ec02adc0303ff200d7699afface2d9fbc7350664e6c6d4c527ef11c2e82"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ace8cfa3bb4ebf1bd459e1f783f9c0ba0699b31445aa2a04e9990d412eb5497b"
    sha256 cellar: :any,                 arm64_ventura:  "c1114b9cab16660d7feddb61fe3f94dc44fe9dd92db4c11baf54e722b5976eb1"
    sha256 cellar: :any,                 arm64_monterey: "8ae85502cbf0ee6916d8690a5d9d6362b2198d1ab256597669062c0be123a505"
    sha256 cellar: :any,                 sonoma:         "ace9fc6b921f9446487450c01d4f1078572d3e73aa5d4b2afc8e6b43dec0a70c"
    sha256 cellar: :any,                 ventura:        "29dda70ef2b13881c64806358b9588f89d8dd1c28afd35f6f5f419a910b59785"
    sha256 cellar: :any,                 monterey:       "ca03a79837f183900fcb242672ef45a68c37b1e7946901ff6f431da92e5352cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dc70103455a4b33e466a4eec58c2c0aac0be61914178b87533be00999653772"
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