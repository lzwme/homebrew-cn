class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.88.1",
      revision: "b2900b9b3d4c8510cbf45cc6c9c50906396dd419"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "187c5fa017bcf0dea08f38d932c35b4925a75f9f3c93c0b6196c072d7cb93013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b4684ce21cca5751d832493305d17cbb6b758ce07f31e43d7a66081242df479"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4b1b25ebb5ae72fd34be5a4a33276121acbe0327dd8006046f8e5572aae9303"
    sha256 cellar: :any_skip_relocation, ventura:        "85ff2c0887e578cd08ed6fc444491f83628229c0775a7586a798e2d147e0c83f"
    sha256 cellar: :any_skip_relocation, monterey:       "3deae13944ad37788c68a271aa3da82c42065258fc9fe98e56f47a1c4dc16c09"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6dd4ecd66eade7c6495db1b04c5b9782e14adb29663cc7dd5a03a3f383c415f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd92bcd1bd9ac5d9d249dcf1df076ed01901605846c8fbdbeb13137c61dfe946"
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