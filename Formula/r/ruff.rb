class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.16.7.tar.gz"
  sha256 "c3114db827dd947aa96603387318ea0099c65c6d88abb2704f9e63fc11407097"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1dc91bacc32051b1164e25df5d4f7b5907add85adb0e75e97569af455ac0f45a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f21d7f3752f60fb7019e2a883e56e83f377075f0d650dad15f488c6e1d98b5e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd8058cbbb3c62b2d5b16477ac4b27c937f283b34923c16d80c42942ab7ed73c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "63d780cfc70c398feab6c9faa540e97030274c094f0f6f6f6a0a52f833ff5ce9"
    sha256 cellar: :any,                 arm64_linux:       "e08810d75b83a3f4d3990465dfa26305a1d9f8a3ae5fe3793cee7c535467ab2b"
    sha256 cellar: :any,                 x86_64_linux:      "7f2ca711002142edb4f6a29a930c7540397c3f24d473286770a2d0686ee5b7b0"
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