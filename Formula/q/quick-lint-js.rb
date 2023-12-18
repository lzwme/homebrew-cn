class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https:quick-lint-js.com"
  url "https:c.quick-lint-js.comreleases2.18.0sourcequick-lint-js-2.18.0.tar.gz"
  sha256 "4e729af360be59bf068a5dcd7ce5e365d8777d37d56a35d469a1aad62133744b"
  license "GPL-3.0-or-later"
  head "https:github.comquick-lintquick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab63676f77b354e19de1822cf4aa0c4485e3517d247c5eec846158e63c4d9bac"
    sha256 cellar: :any,                 arm64_monterey: "4f61ecb219533abe48250ca5849dd49b30fde54801fdae3d8f6e8e56ccdec678"
    sha256 cellar: :any,                 ventura:        "c449de15cc45af99201aae4c99a03594e20ba766451ecb9cada8d218a445ec0e"
    sha256 cellar: :any,                 monterey:       "584d5d8509c619bf9738d491b5d4eb9532e1706e8df0497e5aec79316387a3cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bba62728cc7c77b157418f1629d8e0ca1ea8a2e978e1ebf553aa51ed4cc5729"
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
    (testpath"errors.js").write <<~EOF
      const x = 3;
      const x = 4;
    EOF
    ohai "#{bin}quick-lint-js errors.js"
    output = `#{bin}quick-lint-js errors.js 2>&1`
    puts output
    refute_equal $CHILD_STATUS.exitstatus, 0
    assert_match "E0034", output

    (testpath"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}quick-lint-js no-errors.js")
  end
end