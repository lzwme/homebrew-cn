class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.16.5.tar.gz"
  sha256 "c447968b1e608450c973d441fa87f949f676064aec2db458b557e8222a4eb252"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9347fbb908789c5f2e4a8390989660a1b54ad9e22acdadfda642507f28b6eae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54f751a405163096521c58dba1937a4e8ff32e0971c28d56450481d5c125f78a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49488c0be3ff035e6918c9fe2ec1cc7a1e8ce5aebf5caeb9bfcdd1431f84be3a"
    sha256 cellar: :any,                 arm64_linux:   "7d207e6d081aae5eef876376a69ac4c3ee52a185b9d6e387874fba60ea1e2704"
    sha256 cellar: :any,                 x86_64_linux:  "fcd2b4565b7f9b2fd31796d8d004a01c440cc860a52e6e0d7f31835ad9915d3f"
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