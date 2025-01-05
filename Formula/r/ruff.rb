class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.8.6.tar.gz"
  sha256 "b92fa663b58089325bd0bd0d3732388adf7b9602beef54a24f0e7d9244c665a9"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6700757ce6f5965413006917e32d33980447959c303c1fab2fc56637bedd98b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92be224332a4fda0514fff4ce0bc773198176bb8af2889b86fe1defa00e43760"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1f3050d3f44b3f57e8376d8bb634bc0d71dcbdb5252cf4b8576c4e4203e7d78"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fff3cf42761e1b9c0e8a994385f326394a6ef3979fddf06da967824c8a9809f"
    sha256 cellar: :any_skip_relocation, ventura:       "f739000b63fb15a4e542fa354080ecbdadaa74a117491c179c3c3072d6cbc98a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361f369412a42255868af118adac32917d188258c7cafa8cf98fd2cc3f02365d"
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