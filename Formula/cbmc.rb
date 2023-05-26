class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.84.0",
      revision: "d5e13f1162436b63c24097ef07732cddf8d8acba"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d28172e5d4ec41ec974e73f9d1872ab59f5c1bdb7d8499c81dbe6d9be376675"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b72363f9904b06657f4213cc1074878768dace59be91c3ba23ca50ae973bd490"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ce473854440b72113961b8df702acefd1d86010bd73ccf32e7571e3dc664cee"
    sha256 cellar: :any_skip_relocation, ventura:        "03c177471cf3cb9ba27e56eaaeca79101bef72bd1c908391a7988ec04d5f78fc"
    sha256 cellar: :any_skip_relocation, monterey:       "f29ea71f204f891ef67d58f43d40e20c37f357706d901e0993d7ec9866170a04"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0025b80146f8d89030928deb1414dbdaed22b4a6333d12ee496a015092c32a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78706693342707e8be8321de6538d1477907d0be42c7ae0d7334540d6b9336a8"
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