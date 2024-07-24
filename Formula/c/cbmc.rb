class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https:www.cprover.orgcbmc"
  url "https:github.comdiffbluecbmc.git",
      tag:      "cbmc-6.1.0",
      revision: "737d5826d29df048493b88caad9b70aa217db687"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f32effc78665b1fafb06b4d679af99fbf8591c336fad3cbcab1683dbb43abc50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ff7e2aeb261286e24350123e9a53df995691af81084c87e555ce73c523d6e6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "595e6a5d86a6bfcf531928d0259ce8dfef6ea43c5ef956ce8e0153c03c258819"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7de38239a31714fa7a542e36e8d57ef4915c78f73a54296307de73753e20c1a"
    sha256 cellar: :any_skip_relocation, ventura:        "c1fd3a73e59942bdc0006387ffb34ecad69af58b953c105480c5372380e58e0e"
    sha256 cellar: :any_skip_relocation, monterey:       "8f2cfdcdd2b5a2d7427734f9373f3645bf7bd51fabdaf203b0c66a789b07a720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07003c3f9a81388fd575dafc10723733b0d39acbe429f45446326a361a68afac"
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