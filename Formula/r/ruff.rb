class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.16.10.tar.gz"
  sha256 "c8ea3637edc68ac9d17c9143a2a432540370e3768a220b9978e931e5f89d6260"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df86620e14bd30f33977b11f46b7513bec55286f4d92d43d3a18b12e49c489ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eee28c6ef8ec764656df226563dc231c6c135017b0b5039e6464254b96809e59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca15f84169e030c82e49facb0bd1eb38dd65a0737eb19b8a12641ace67d1ebff"
    sha256 cellar: :any,                 arm64_linux:       "62f740222c3e171a4e7f1999d9ae35659cfb159fe46d13a0600513b748415126"
    sha256 cellar: :any,                 x86_64_linux:      "ccecdabafc66dc2025740fafdca022905889d346f82bb950cf0d0d0cb38bb415"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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