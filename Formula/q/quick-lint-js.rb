class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 14
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a86e5a658a35d975112c2d18e732ee4210a7b04982d04fea57adf856ce29633f"
    sha256 cellar: :any, arm64_tahoe:       "63a00530e13563440dc6fc6b0b0805d969efb5e1947abd1da7c3c2eefbf1f5ef"
    sha256 cellar: :any, arm64_sequoia:     "1c67806e60862b2a8995acd24e7de6d0d57eb3d195d2c8b9b4580ad6c38d849b"
    sha256 cellar: :any, arm64_linux:       "879cfef7baad0a2cd901a43dd37fa17aee5223a191478deb47cc8917a6c03915"
    sha256 cellar: :any, x86_64_linux:      "4bdcc76ac104b49544c68faec836246ec34464fa0bca17233b00ff8589d96231"
  end

  deprecate! date: "2026-10-29", because: :repo_archived
  disable! date: "2027-10-29", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build
  depends_on "simdjson"

  fails_with :gcc do
    version "7"
    cause "requires C++17"
  end

  deny_network_access!

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
    assert_match "E0034", shell_output("#{bin}/quick-lint-js errors.js 2>&1", 1)

    (testpath/"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}/quick-lint-js no-errors.js")
  end
end