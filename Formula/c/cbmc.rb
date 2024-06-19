class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https:www.cprover.orgcbmc"
  url "https:github.comdiffbluecbmc.git",
      tag:      "cbmc-6.0.0",
      revision: "a8b8f0fd2ad2166d71ccce97dd6925198a018144"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aca1b76ae26e8fce3480e6e0577824e4b9d6276132d8a30e73afec9a318e2136"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "067c119a328a6b1013479febc8e1a727e4c7541e0eabfcb2b41e9fc0d9685b13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "634005dfa247a3804e0a48127e66d2d816b34e013b6aba6efc83ef092f5822a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5fef7366571b982fda45de9f8cda0db4373325a8ae7fce2be75f23ca6452a20"
    sha256 cellar: :any_skip_relocation, ventura:        "5e72faf432f97a4f3b01953e67cb117e209ce2f2ab0e4acfa0460b5b8c21aceb"
    sha256 cellar: :any_skip_relocation, monterey:       "2a21e600f37e7c9c7ac2387d3a98b2543358ce438fb571881389cc6d743b9800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445207134f77b3fa50ed420a143e382dbc20fb315f83dd441e7c676b382a61f5"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk@21" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  fails_with gcc: "5"

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