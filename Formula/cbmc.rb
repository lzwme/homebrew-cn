class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.80.0",
      revision: "a9785d3e25e5a1b20bc85a3ba02a6207751929c4"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d20a53c8acb5e70f7ae108636c4b23acc1be81a3da5c4a9dddc683c3b268428"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d0aee941af5addae02154f283a823c782d87ad549baa575ff2e662e9a485c28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee1bff8f19ca2c0028905a2bb10f4460fdf82e4fed4d50a03ec600a711c8df54"
    sha256 cellar: :any_skip_relocation, ventura:        "f7419f7b354e8844f4ef8f5fc29344504a48b7d771aa1c81c3cf065b6d0a8793"
    sha256 cellar: :any_skip_relocation, monterey:       "7dc27a5cbd6b3ba376f0e6667f729eb7c4c376517920fcb034e58a777d926280"
    sha256 cellar: :any_skip_relocation, big_sur:        "6156844daadb1fb7473fc4822df743d3e5538a38af237019737cafe080500d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e72071e8e09c6ba0fe5bcf963689ac988ea6f92cb37f2ca248651bffbde61740"
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