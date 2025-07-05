class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-6.7.0",
      revision: "5d1438a883201a8983b1449eb2485df0821c819d"
  license "BSD-4-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7becbc8bbb8bf19e4117619a38bdd327382327e7ae5e9ea8d4a67eeae90b838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb4023fd3a987c09ad476a4b23bf4a4169c2f679ffeb7ff9fe7ff54fce64ab5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57bcd93ceecdd9c6a6b502793f4430f5904350f8cfb0b70ba8a934e5c5fee7be"
    sha256 cellar: :any_skip_relocation, sonoma:        "f32ac34db6255e3beeabbd817411ae696032bddc68442c8a6ddcdf3de0147b0d"
    sha256 cellar: :any_skip_relocation, ventura:       "3a206657edd5de624267a31015ccda82fa1351d38b1b6289d8a14f7f80c947bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1ecddb0d843183648927b936b16ed1307b968f9f7140187907f61f34f2436ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2952e3ae721388b49a2ec58eb1b55c291e904246009af1f699334aace3b70ac"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk@21" => :build
  depends_on "rust" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Fixes: *** No rule to make target 'bin/goto-gcc',
    # needed by '/tmp/cbmc-20240525-215493-ru4krx/regression/goto-gcc/archives/libour_archive.a'.  Stop.
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
    (testpath/"main.c").write <<~C
      #include <stdlib.h>
      int main() {
        char *ptr = malloc(10);
        char c = ptr[10];
      }
    C
    assert_match "VERIFICATION FAILED",
                 shell_output("#{bin}/cbmc --pointer-check main.c", 10)
  end
end