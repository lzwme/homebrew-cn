class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.14.0.tar.gz"
  sha256 "c70834fa2c2ff7c9daae8f69010310be4f97d796b9caf9b9a3a83b3a82113193"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98782235ffb40a3c52af7df472bb77b9756c19d7c5cd8ca153fc25df92b986d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf08c3bc9a840938ed6810430a46f5b366fb2f86b93717f4ea1c63147d1598cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "148b08547c1a94e39f299af8105217fc985c159019b43504d1cd57e76941638f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f2f3cc55671e79ad6b8ae62deed25ea66b0b7d4e4c5eb9b9ad56330a52a3e16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4feb1cc83e2e7e9120d1446b38c3b6815683784df1f6aa6571d5751b1d9ea314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "945fa83e0214cf62ddac2b5557eceb41fcc3ad56633c5b2b2f5ce09745eb961b"
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