class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.16.9.tar.gz"
  sha256 "3b75e09dd9cf0fafbb2ae1fe13bcfdb4d43d3c07cd8578e2c48bee86b2d328e3"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "075822552b9a9117154334536ed36591ca1b9bba8922f2da50a0b2cfaf33b992"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64ef88de56f357dbad5b7f2a8ab81349d239eb40dddf9b075422aef346e2f640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6448ad986d6e13f2f2c0bd1f4ac59017d5c797afe5f63df8bc5035858482be4"
    sha256 cellar: :any,                 arm64_linux:       "995d3ca7767081627c7465c8b0d6bf51b632923949f7fd779da54bb98cf19683"
    sha256 cellar: :any,                 x86_64_linux:      "9e6274b8e3a2139c4d797f3b11c7d826085e6290cc242258579652f6bd41f04a"
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