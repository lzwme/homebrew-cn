class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.83.0",
      revision: "535e6b2d266566c47f47339677ac225f39454944"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de5d9ec713028a5529b11844a166847ee4c6016b7935b5a0c9b6b38e93c9ba63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a15f7cdbef60ed8188b1d5aec4544d177c8b122986cf5c6c9fb483e1b53d18e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82e1d7f15d55716856a3991c38b033d456c744d9c4d981538353a67f2da1e607"
    sha256 cellar: :any_skip_relocation, ventura:        "6e6675b84fe26723e92a0683c5a8eec03a9c372a9081c2733f190984e8aa1700"
    sha256 cellar: :any_skip_relocation, monterey:       "cd10e6b7adc627ee8825c62e236f449fe6bb12195399a21a261e3d31d16f95b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "157d2318911615a565c253f905526d8df080d47b1360f3a83afe084cc229443f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a725c5a0864fc0dbcf768d1ae0a98cd3c3690bab8a46d04279872f9e6df1d9aa"
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