class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.17.0.tar.gz"
  sha256 "2df40dc573eb751154b49055d0949668ec4f72f928d9c7fe5d86f451bfb3d7d5"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8edfde04114bcdad3e1d459f81d3cba6c500361a7334cace2070cc2296f54649"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dede98879b2dd98599efa1195874ee03585c738a05f12eecf83a7de08fc9363a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d0f8f0991abe7020728c1ea84dfedc4d7ee0ba4a4da7256d1865e5a97dc69bc"
    sha256 cellar: :any,                 arm64_linux:       "7226ce40540ebc589a44139de41e6ce46922a6d6ab8aeca5efd00771c047aaca"
    sha256 cellar: :any,                 x86_64_linux:      "0c131cdfca9c67249b01380a0e31d69b5f4ecc27c0fa86f8ef6fe828cff1796b"
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