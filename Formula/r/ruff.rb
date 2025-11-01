class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.14.3.tar.gz"
  sha256 "e44ce7ab8c6c0894ae4afcaad086624ee1279b7c3e1e2a7dfc5face14800d80d"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "871bc9930b313eb8d56fe96d09cede7ed6487fc710b8af41a5459b88e10c2efc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49627ee7bcc7fd6be1f5f20b527a697ee114b87386f953f4cbab16a6494cd705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e00b9b5c66782545c53adfe60a764435fcacb679382813ad43a4015d20b1b76"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe218522d7df712e9ae1e811e136692c4bff81ea7251aeea145302859067e0bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c89fcf19f3f4ecd309b3e46bfc74dbf02a8ce7e41ab4a1a8f3e1b0b927a1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c19646abc49a1ad5c5bab23fcc4c382573612ec3c31b02d12b1335008d32e0a9"
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