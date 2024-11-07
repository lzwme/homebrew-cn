class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https:www.cprover.orgcbmc"
  url "https:github.comdiffbluecbmc.git",
      tag:      "cbmc-6.4.0",
      revision: "4f56b6a911911fe89c73e2b6b58c96852e8b233d"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f35caffd7f789cc052591dcdc96929018e1de188ddc36f706e00f0884db4ea4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8898d785e82f2a5a2e88b6973f1036a28235907c2fc4fca4418d661b43d2de7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a22afc1680d62d4bfc6815e7f2de5f61dd5fb452babdc5129b8df41b048fc979"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f3f9004d77e6eca5f10d05ee23d96e31dba2086b299810b52b5d1813e099aa9"
    sha256 cellar: :any_skip_relocation, ventura:       "00ac7f3f6c95c6e974d3a93b29efc6b664f9430ebab4c0d2dfa50ffdd5a700e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c010f61202ddf3d679d7570ba04eb75ba0480de6c7c436793328f60064c7c68d"
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
    (testpath"main.c").write <<~C
      #include <stdlib.h>
      int main() {
        char *ptr = malloc(10);
        char c = ptr[10];
      }
    C
    assert_match "VERIFICATION FAILED",
                 shell_output("#{bin}cbmc --pointer-check main.c", 10)
  end
end