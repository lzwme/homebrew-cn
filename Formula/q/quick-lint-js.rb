class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 10
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49d03124a83f370f4a9cf64dbb426d63733316f6e8360751f41f6eabd8df7ae7"
    sha256 cellar: :any,                 arm64_sequoia: "7a630eeb8cf9128abd1ae96bea338aa598a5d4f8dcc072f168ea32f6f281eae9"
    sha256 cellar: :any,                 arm64_sonoma:  "437a3e91ecab5a92b40ab67016000d144a64f9dfcd97c9849ccd43eed596644b"
    sha256 cellar: :any,                 sonoma:        "40ad5c3c8e7d7684cd010f435d55a612565e9eac743d3345ef9f79b43e1892cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bfb07780c00cef9046794798275f7e68cfb5ad9438ba98a9fb7bd33394a6881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6171fc32f3961b428ea0799910225576b405a7cbb3f21a1c051f8890a675b0c7"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build
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
    assert_match "E0034", shell_output("#{bin}/quick-lint-js errors.js 2>&1", 1)

    (testpath/"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}/quick-lint-js no-errors.js")
  end
end