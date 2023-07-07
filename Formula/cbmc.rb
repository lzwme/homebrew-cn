class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.87.0",
      revision: "5650fb9e116291b44da32341db4288a3bcff0fac"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1446a0982ec176feba81f4adba722430492e3dd5ab91adb3a37de287945454be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f07d4377a977da770d25bfb89938f8d768d02fa797113f2c76cc8b59be682a44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1465a9116a6afeb5a3aa3d81aca4fdb67deaad7191dbe362599e1b9ab2a8bd58"
    sha256 cellar: :any_skip_relocation, ventura:        "a1974330a69c31e21febc1c3aa6bd8a655d3e26fd532aaf47a8c5956e9e572f8"
    sha256 cellar: :any_skip_relocation, monterey:       "996810862f0444139f6c2529788bb492db1ae7c8acbbe02f9ad76eee6f0ecbf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0118d27e5e9b63124f67c438adb6edd02e239dabbd1c33b780bcbcd928b945c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e72e47fc7c63d4bb167cfedea1312082114cb33f58b8af78486911d635e753a0"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-Dsat_impl=minisat2;cadical", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # lib contains only `jar` files
    libexec.install lib
  end

  test do
    # Find a pointer out of bounds error
    (testpath/"main.c").write <<~EOS
      #include <stdlib.h>
      int main() {
        char *ptr = malloc(10);
        char c = ptr[10];
      }
    EOS
    assert_match "VERIFICATION FAILED",
                 shell_output("#{bin}/cbmc --pointer-check main.c", 10)
  end
end