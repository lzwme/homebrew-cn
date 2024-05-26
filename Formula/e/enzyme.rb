class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.116.tar.gz", using: :homebrew_curl
  sha256 "b90a0ed918994d0f363e52a42cc3f7dd7980ab36c8ff18c91d94c5d7eaa00eb0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6fc811b784e900fe971b0676fc1697a1b8e144d82664abc31be00f7d23054491"
    sha256 cellar: :any,                 arm64_ventura:  "488c9ecc3eaf6d4aebdf3b17e2e46f44d149716d0573b187809a6c5f89e3d6fa"
    sha256 cellar: :any,                 arm64_monterey: "3daf1a952009ffa3a385ae834b1c4da3a7075c4e36808722e58c05041163aec7"
    sha256 cellar: :any,                 sonoma:         "02e2aa40c4e3c4055027f2a3bea6a7aeb8566340e015db771ef22d9594bca84e"
    sha256 cellar: :any,                 ventura:        "b6ef95c627a51b5414acddc6285a7e8375202399fb268d5e3e3cb24c4f828990"
    sha256 cellar: :any,                 monterey:       "624154421d5bfc6c7728c4327b4ae172df61405d8f63d1d5cdb0c4d54d755328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b845c72747d36103f1920f2aedf5848fb2559ab8f43c9f493a456d21e477446d"
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