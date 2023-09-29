class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.93.0",
      revision: "99c54024b4911bfb2c6ed4fbdbe33d199389896d"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b0aedf45666a0664b577df29f534763df5cb5c670285ec9d4c768201e816a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fe2411d7a62c3d073bf007fa3a48c1237322a7429be7a1ae6b6179b0310095e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce4caf2024a073424d7563091b36bd95d80a20da67bc1cfa6ad819b1458ac08"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e96bac9fbfc3fd899af6918975d31fe9d3cc79f0900da600c27962dc3a821f3"
    sha256 cellar: :any_skip_relocation, ventura:        "487855d54e433d451c4cccdc3185d8b8b8914c39a8d48b3d14b02922fb12c89e"
    sha256 cellar: :any_skip_relocation, monterey:       "230820db7b18292f1218f5f31641cf421eaf27a3f8b6ca346537236c5d1011b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d753015adda6d7ea1b85876d091bebe1831b25c37c769f12356d7ea74e4371dc"
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