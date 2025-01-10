class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.9.0.tar.gz"
  sha256 "392a9e5bf717731bbf48e29174cb0e9e96c45c7037d0b54ded69a1ef867e41a8"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e86602622bf410c7be328e53a1a24638b7812562c543a2d80ecd61d5d962d67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29214cf601c5e5c6b53863e4bdd072689c57ee111f464a074eeb6fa9c02c6482"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "612e9c5bcd0eeafce7fbe07785ddaa6dc2e44fe81e6ab715626ec21f3cf665b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fe0087d673959b1f26bc99761c88226ea2d78bd8c5e8198396b35190279f649"
    sha256 cellar: :any_skip_relocation, ventura:       "3b546434e06851633c156133fc1754014e51e14e0bff3f0769f46c94d513953b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c97625dd5b0ec74a90b40564dd765614349937b66de5e31be776e081db901e4"
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