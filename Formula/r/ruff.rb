class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.9.3.tar.gz"
  sha256 "b80486d27260530bc5ed1348f701e22a984dc15511add374e990b7e0dc5844c0"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f39fa90e26b619423407a583d42c00078eb6a6b9b5550c790a0cd95232bd4e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d736f8cd33aa4b43e6e52dc6b6ba718fd2fd71a17c7fa7fd373f3fe786a202c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "810215879118444c2ba217383197edb1f9eed868721f753bf85117147144c6ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab64a4da5776c64968b3de8eeb347eb281ba84a6a085ccca962b775f26f31c8"
    sha256 cellar: :any_skip_relocation, ventura:       "3b37ee9e082b2e1e4027c96af6d4f3e51f9cd4eee8de6dd9fad430336b30f179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "793df3f2a3257b9ada6e28852ecdfd24079367863260837fce47394207fbe2a5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesruff")
    generate_completions_from_executable(bin"ruff", "generate-shell-completion")
  end

  test do
    (testpath"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}ruff check #{testpath}test.py", 1)
  end
end