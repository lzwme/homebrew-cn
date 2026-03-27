class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.8.tar.gz"
  sha256 "bf7a6dd6833df79fbe1498f60827c14a8113b00a478dd52f09ab8f77ef7e2c51"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af284616d6894ab0ca8808fbd1e79e98dcf440046c4ec2da4054b4a1e7729ad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcecd1ad73ac44e52ffb0a39f21e3d9adfaff9d26ac1cea9aa7a8628d3be524b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aa60c4ee6da6f03def0499011eb7ac7d735ed7d4376bd4e0411c3ca7d992daf"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d71fd2c2b55d6aa484c74cdf6ff15216aea78a03d67c00d4300bfefc76e85e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c098d24cd709f87e39bce080d3d94e548f3395ab9cf3657d465d1c38f3d55f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d1245398c3be3bfde9f0077ac737aa97485fba9c056efbac3ee5cc72f2f123e"
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