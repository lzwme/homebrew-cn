class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.88.0",
      revision: "63b8b71ae8ed1ca86f8db29c5a738923cae1dbef"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e373af47d5e908405e74d119e2ffa3c7f461c7ea85290af26aad1d7b7705adb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e16c7b41455e6d3926bf648fd7f80d93413e922d00c3a1e7ef156df2b2f24908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a0469196703978753da01636dadcf8e96e9e2c3954a2b3dc49d066443250816"
    sha256 cellar: :any_skip_relocation, ventura:        "c856ba50eea9150ee4cee5da0b68a0e55f6b4de36d0e3c4826bff2351391d6b2"
    sha256 cellar: :any_skip_relocation, monterey:       "14937495b824ca6ec5e734eeec630f52edb81a180e18a4fc9114943cdd030bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "942f1d1e65ef1d62f78aa41cc776a29ba32cecf1ed262a9af294ac39b64bd899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8529f10bb069ec1cad5b58526b4e3247cd05649837a6dad5ca558b8f1149fbb2"
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