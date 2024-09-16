class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https:www.cprover.orgcbmc"
  url "https:github.comdiffbluecbmc.git",
      tag:      "cbmc-6.2.0",
      revision: "27b845c975c6bbdfb2ccc6f40bdfae6793d12277"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "547be02ac0f433c32c3891ae903a0fd636b5f969f0d48f979fb2bb297120b997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2498148a8885ca9dc4bf43b74223fbb6133c751cda63fb4696c77a289c05077e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf25cd38405568e00ae636911f9d99d9e11bd3af412347e35493b546f89e19e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc6541c50375420b8039db909c479357f4b6ea08c42b662c848116c545244235"
    sha256 cellar: :any_skip_relocation, ventura:       "98ca34ae1079827e7db598a4548dd53f736c28ba675fa2ec8f071bcd9f8d6ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5f6935072f1af26fc5559e16e5c92b06bb6da0d2a7f80e6f1c2c155215bf1e"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk@21" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

  # Backport fix for CMake Error at jbmcunitCMakeLists.txt
  # Cannot find source file: tmpunitunit_tests.cpp
  patch do
    url "https:github.comdiffbluecbmccommitfaf92c5354e3aaca6c70013bb75b26a271c6f63d.patch?full_index=1"
    sha256 "7dd49f1364a24b914e13e3e16de7611db10467f1235e308d1c7fa77291171de6"
  end

  def install
    # Fixes: *** No rule to make target 'bingoto-gcc',
    # needed by 'tmpcbmc-20240525-215493-ru4krxregressiongoto-gccarchiveslibour_archive.a'.  Stop.
    ENV.deparallelize
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix

    system "cmake", "-S", ".", "-B", "build", "-Dsat_impl=minisat2;cadical", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # lib contains only `jar` files
    libexec.install lib
  end

  test do
    # Find a pointer out of bounds error
    (testpath"main.c").write <<~EOS
      #include <stdlib.h>
      int main() {
        char *ptr = malloc(10);
        char c = ptr[10];
      }
    EOS
    assert_match "VERIFICATION FAILED",
                 shell_output("#{bin}cbmc --pointer-check main.c", 10)
  end
end