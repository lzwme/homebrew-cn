class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.14.14.tar.gz"
  sha256 "6a6a952a0b273df14eadd4e5a61a48fcc02fa268d2b258062bf332e6b53d4090"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddec97fd2773dab9c72ddc73e2e70c0e1bcb158ead7c268c9d5ab8ab79ac6018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3cd766e7e5b379cca648133b4bc284b1e81fb4259a45f147e0646839b7b3f56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a193a21ef0004916e63c9cfbcf59350f7a51afeac16a5962c22187ff741811c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef68ce227e562af3bb808008304f61b6b08a553615a7956d0686bce1f0476d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca60bc4d85f07cd1915a9179a6ffeeef487d866953b2866691548042f83f5cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "924025a0a8d8f25b59f4ccdf245f72d0b31b87c3c315e3d49f99d42ad0ddbb06"
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