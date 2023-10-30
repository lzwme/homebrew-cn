class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.17.0/source/quick-lint-js-2.17.0.tar.gz"
  sha256 "8a7ed7f7bcc664da23b7d112bf03d0cdc747aed62d5ba0f466ce1c2998e94966"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "779fd853d0db71d6a308523b60ded54645b48903936dd8e0f880bad20d44c043"
    sha256 cellar: :any,                 arm64_monterey: "7d7d5520ce371041254ae0c983ca53eaea4d3465dc3be2da116c93756c831060"
    sha256 cellar: :any,                 ventura:        "5191d3ba3d41f2ed484acee362b7abab61ac77b848a94b80aa292216121c0c50"
    sha256 cellar: :any,                 monterey:       "2a3bb908e15ce2d4f75515b5e40fcab612b133237190c85040e57142cc1980c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401ce90b74bbbc1e48aff76a5f93111b914cf2bdbaa5e13a0c087476c320cf51"
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