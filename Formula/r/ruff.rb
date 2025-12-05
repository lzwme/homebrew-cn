class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.14.8.tar.gz"
  sha256 "a28c4703a813c20332853a11eecb3a2aa66d7cf74646a44f94f754a4a98aee52"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1179765c9a03b73823413258f23bd04ada89e17ff4ca34f995560b6884ec8dc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8be2724bea9840f30a9b898f06b1e400b40664ef71f6e10672f918c2827c151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5497e1c553bf5de380a182289781e9bc2e99b601a1e95c6529e07bfe5284d9df"
    sha256 cellar: :any_skip_relocation, sonoma:        "f35ef93d5403425a61d7456c1939f23245400295bea898b2fa697a22ef260be2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c778d2d85348e1eb6dced92b4d32a5b175662c0edec44be5d93e8c43fe1c6a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6349c611c0297f03f51d1b703d149f85534fd54fcc33ffa66340eb05e06278bc"
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