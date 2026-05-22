class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.14.tar.gz"
  sha256 "35d50bf820ee54bf5a9d4fd1f74d196ef44b9c34ea7c18dd8acbd4708c0ab496"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4414e87157a0035a3891aea9a9e7c9ba70f7f298e37a4b95c3b6785bdaa15a6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23cbdea7cfdfc038bc9cd61504b9864f7adb251500ce9d6a17a38ea46641c1d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fd218c59a962fd89260538bcb29056692961b9d5286cc4d96a008b94bb96e52"
    sha256 cellar: :any_skip_relocation, sonoma:        "455246f4efd6514e76a556e8609af3fd3b7a6bf0c3863d5baa702b0bb2f81ad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67695b0b3c83f983f5006289a1b0e405c7860be7e3eda3d10ca3cdc63ac0f897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a29a64246628eaf7c0430bc2394f49ea8fe0f647c3e29686bd2f79148b58a17"
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