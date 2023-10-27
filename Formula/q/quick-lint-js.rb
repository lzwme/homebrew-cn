class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.17.0/source/quick-lint-js-2.17.0.tar.gz"
  sha256 "8a7ed7f7bcc664da23b7d112bf03d0cdc747aed62d5ba0f466ce1c2998e94966"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bbcbf4d49f3bd9b3d60aa40f4e79ac764f8f494b0c3938f3e472f01c615a178c"
    sha256 cellar: :any,                 arm64_monterey: "f8c965797b49f699a8774316e78f5b8269ce2aa70938b03e20ae5f962641a8ab"
    sha256 cellar: :any,                 ventura:        "08048bad11c46caffe859860d7846e263f25c41f75438c00833e378acb6209b8"
    sha256 cellar: :any,                 monterey:       "34c4074476d5056ba29211beca222d9e842fca6321561108af8a456b57896eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b24f7f4efa6e7082b2bad45f9ee178601ac6987438f1c7ab1ffb30eaa6caf492"
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