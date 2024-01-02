class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https:quick-lint-js.com"
  url "https:c.quick-lint-js.comreleases3.0.0sourcequick-lint-js-3.0.0.tar.gz"
  sha256 "86f0e1411d5c5bb4ee1ab79e5cc1339e0f2d1c5a208b99986128b2939788123c"
  license "GPL-3.0-or-later"
  head "https:github.comquick-lintquick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d770aeba1b38af4be3ae1876fc811b5f2ab0ec3c21628d469274daa6f27ccfec"
    sha256 cellar: :any,                 arm64_ventura:  "f0562096a00a427d8b74fe83d3a5a3a20000b4a09eb2fe480958f82b1e1705f7"
    sha256 cellar: :any,                 arm64_monterey: "ebe340ee2dffc4be689a9295aa3ef92539de49179924097c6b346927fea8bf70"
    sha256 cellar: :any,                 sonoma:         "30c853a1e9cb074a3b5bdcfad4460c76aadf836e730e6743c3602b16b59887eb"
    sha256 cellar: :any,                 ventura:        "f965711fd682da27e35e132e389ca7cbf223c5c1088f9cdbd062f742c15fd742"
    sha256 cellar: :any,                 monterey:       "927dce963a959bf17dd1b20189ebeeb9515dd9d206e3676b1ecdf5513b201bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54cc5bd2203ac285105fdea276e82271a8a18bc49173517d6352e21ea4c7d3f0"
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