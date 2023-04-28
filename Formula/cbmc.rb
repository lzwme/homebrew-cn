class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.82.0",
      revision: "1d0ee456728d747001dbb9f9098d9255adaf9d28"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c1ede1a24fb872ea5fb25b39cf529c66a508a4fabb49dad9bf324c98e1fcc86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "994da04feb7a91c54a4a4d87202032580eb560457ab0cce2aeedfa9a22d84f33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b82dc9ab195ec3b455a82302b6ecd940c9a4284d7d4f3ca6084d27e18711fd3"
    sha256 cellar: :any_skip_relocation, ventura:        "bfa857fe3f3a5fce6f099ce46c292de2510c987805672662dc0077d5ecb17fc2"
    sha256 cellar: :any_skip_relocation, monterey:       "fcb753a5ef393139c581b73ae7e74693e915b46ee29f136aba53b3156c1a1dd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e612745f446ca24ef5456f61688fc10092ae412fd3d3a78d260819ba9f608905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b835d5762bb1cd4535eac3eddd151b3a562c25aadca3ff59fa5c3661f31255f"
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