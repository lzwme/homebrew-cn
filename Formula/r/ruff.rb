class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.16.1.tar.gz"
  sha256 "4d3b052fcd52c66265122fbaa0c4e867f3dc7c3c446c93c2ee48fe489ab8924d"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9617d0368e8349263415d130615d6c13682ac6a61c9810300fbf507c9dc1f9a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0d532d5c5c654045a55b42921adfdce30741bdcb4289688912aca3f67814a31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "982e807ddb6849ad4d341f2f9311aa95b81151aad17e1fca4b1e277686354f3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f4dee99a787ba848d2c2bca34e80fc986b1295cdec389558499521328271e86"
    sha256 cellar: :any,                 arm64_linux:   "a1d6335cb1ed79e1e349bc0cbea53e478b1c219edca4754f46da9ef7d850b8a4"
    sha256 cellar: :any,                 x86_64_linux:  "4314ca1a73eecf5b4ae51bf2c55bb2f9fb7e386100cd808b7989bc7d4f6b78a4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end