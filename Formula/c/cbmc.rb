class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.89.0",
      revision: "1ecce42cace1128ec32744e9cc396e3e8e83a9da"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14317b1b3b0f14c1d9cdea85989d80cc15795e2a15b07c0ae122dd44859cb356"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61cc5cfd10b46ef04e47c0281ddbb495ab3784454b04f3259ae95b7967df0ad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da37c108a11ea3f644e69a1fc7b32ec817f0f197ae3f3c66e19b906c109a344b"
    sha256 cellar: :any_skip_relocation, ventura:        "08bea56f0ff8660e6d63c4b0faacd0f6db3589145ad62ed361d61907bf811075"
    sha256 cellar: :any_skip_relocation, monterey:       "76f47075a236744a0461bcc73bbd4342644c8800a5f45c40f67ec7d567185f3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a62b5da5895a6748358abfdc17a71ceebc7adc40142ef1c4c01e35e035b27746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72dfc2e0307aed69d933fd97472217ced62f22449b6e2b820c5b294e51cf915f"
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