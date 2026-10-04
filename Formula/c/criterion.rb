class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://ghfast.top/https://github.com/Snaipe/Criterion/releases/download/v2.5.0/criterion-2.5.0.tar.xz"
  sha256 "740d5a9c00ca6f58f59dc20ba1ebecb3505d28287a8fe4ea3029c7f8a1906496"
  license "MIT"
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6cb671bafa44818cdc8754d27b91434400ffa80ded53328e935d937da1d04538"
    sha256 cellar: :any, arm64_tahoe:       "258f7fa60a5d5e9c7d7f15ce59b401257545516233cbac31e169bd5963a507eb"
    sha256 cellar: :any, arm64_sequoia:     "dd76264619a9bf01c2f4702b6e254226c9599b95134ca97cbc9ea7444982cad9"
    sha256 cellar: :any, arm64_linux:       "25a2c43c6b9a126868acb986505e6dfd535c7ab54b4d1beeca9e3ae764b2acd7"
    sha256 cellar: :any, x86_64_linux:      "b526ef74e797e8467b6932af194e1a4faf3813796f470d1588cc4ca01b531741"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libgit2"
  depends_on "nanomsg"
  depends_on "nanopb"

  uses_from_macos "libffi"

  deny_network_access!

  def subprojects = %w[boxfort debugbreak klib]

  def fetch
    system "meson", "subprojects", "download", *subprojects if build.head?
  end

  def install
    system "meson", "setup", "build", "--force-fallback-for=#{subprojects.join(",")}", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "--skip-subprojects", "-C", "build"
  end

  test do
    (testpath/"test-criterion.c").write <<~C
      #include <criterion/criterion.h>

      Test(suite_name, test_name)
      {
        cr_assert(1);
      }
    C

    system ENV.cc, "test-criterion.c", "-I#{include}", "-L#{lib}", "-lcriterion", "-o", "test-criterion"
    # Running tests needs the runner's `/tmp` Unix socket, which the test sandbox denies, so only list them
    assert_match "suite_name: 1 test", shell_output("./test-criterion --list")
    assert_match version.to_s, shell_output("./test-criterion --version 2>&1")
  end
end