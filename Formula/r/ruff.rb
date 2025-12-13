class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.14.9.tar.gz"
  sha256 "cd35644f9ec245ce3b550e9941cf2bccfd2f184581e3540693499b9c61217ec7"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68c5952417146d616d4054e44d33c1ac051d5bbe9a658280cb66f7abc9b2ba12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32d58b7acd86aa196263d6f5902e8ca8511ea14e6ada93bbc8aa6a3c921b469f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ed4e54bbdd3ef021027ab298435b5b76a912a0d7c0850c79cfdba5f50623be"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ad12b77b29b63de17e1a8f662064556934bc12054e77e7d5f40732bfcc1d97e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fdab33bd3a88b6d3a5592e9e9fe67c6d0c307aeecf3a37f5299575560f7fc7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8d0bdaf5801946e28d07ff606d391d3e19dcb01aa29e36c29966082dacc0b3"
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