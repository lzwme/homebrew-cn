class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.17.0/source/quick-lint-js-2.17.0.tar.gz"
  sha256 "8a7ed7f7bcc664da23b7d112bf03d0cdc747aed62d5ba0f466ce1c2998e94966"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "769a0ef728a215f5c0184a9bc6724a4ac3dae0cbb63476e90668548156790950"
    sha256 cellar: :any,                 arm64_monterey: "5c0b351a5f532f916a6964913b511e054ba5518e844dafd68c4d4e36b3d6fda0"
    sha256 cellar: :any,                 ventura:        "490819c9628870b0f58e848f299e51120f1376da231430e5bb087f46134f18fd"
    sha256 cellar: :any,                 monterey:       "4024270e79971bcdfe3589ed67832a9736cbde679549c2dc47bdbdb64c5557c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f7d6a38fa54dfe40c73d0518bca1b72a23cb70589d8987756b30a156422de2c"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "simdjson"

  fails_with :gcc do
    version "7"
    cause "requires C++17"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TESTING=ON",
                    "-DQUICK_LINT_JS_ENABLE_BENCHMARKS=OFF",
                    "-DQUICK_LINT_JS_INSTALL_EMACS_DIR=#{elisp}",
                    "-DQUICK_LINT_JS_INSTALL_VIM_NEOVIM_TAGS=ON",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_BENCHMARK=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_TEST=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_SIMDJSON=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"errors.js").write <<~EOF
      const x = 3;
      const x = 4;
    EOF
    ohai "#{bin}/quick-lint-js errors.js"
    output = `#{bin}/quick-lint-js errors.js 2>&1`
    puts output
    refute_equal $CHILD_STATUS.exitstatus, 0
    assert_match "E0034", output

    (testpath/"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}/quick-lint-js no-errors.js")
  end
end