class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.14.1.tar.gz"
  sha256 "cc633392bee7bb5676d4c6026f3850ca9f6105eb954fe005690e0fb495a17900"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfb6fe18a7c6c62e00f051b9a4710a14c052b7794b2cd4ebf885a875ae7225ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a59681db37acaf7d56cc705b4cf11f42edcc37a2d2521055c3ed07ca99e9ca3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21cbc78f15ca5950bf15867b882edbecbb025a24997f44a47843940290629eb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac9d0308f5b11d0610391a21a533e6f4e0f018498d5eabe64b74533e98f228f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d9d4f326b56f0707f98ccb5595afa01cf37a5aac5c964db153f17e5d1d74945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef5364f1ad2ee70cf280a7b2e5c53d79dab5bfdf4111027e92d2e90622997cc9"
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