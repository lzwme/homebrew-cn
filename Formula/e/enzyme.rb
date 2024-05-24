class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.114.tar.gz", using: :homebrew_curl
  sha256 "34eef30ee975a7dc9542972aad800af0fb6da6122b46bfecd67d226b134bc436"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "725c3182d7853cc255cfa742a8970446d010a96cda6b408f8463489ed966fabc"
    sha256 cellar: :any,                 arm64_ventura:  "6fc5abb1a9958f082c347e1a1a1ee54e519b99d7ccdabf89a284ddf1369fc924"
    sha256 cellar: :any,                 arm64_monterey: "bb17dc24b46f7230550ae2f93fad397c39a0d666e266fab720e9a19b037dd4da"
    sha256 cellar: :any,                 sonoma:         "e09a1fd3174d8e44cb1d0a5aac64b555dfdd17d82061f02b69868ea8e2621e49"
    sha256 cellar: :any,                 ventura:        "f2a7de38b6e62686a2509c726c16fb6ed4afc7f0b2df65636131f5c0cdc4f9c7"
    sha256 cellar: :any,                 monterey:       "7bdee1957330d93eccf16f1dd0984e778292f3ab5d599346a4a8390c375a42ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d411b62a92b14a9cb826c3f68ce44e555ee605c4af0c79c87a1ad0d9299c451"
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