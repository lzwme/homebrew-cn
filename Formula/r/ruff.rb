class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.12.0.tar.gz"
  sha256 "3623e20815ae84254ca5dec780165e89c2f1947c73824167e3a44d41fde74f57"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda9e5f6e68238e97348dd69b56c59145251a5fc2483c48df2b2406ecde0b86f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ec07023e29e2ac5ea4b42559e406bc19da72b551226ec578d458e1020aac0a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "918a3f4967cbee8caa4021093c1158419660b7287d09b6ed8426ad1e843c8b65"
    sha256 cellar: :any_skip_relocation, sonoma:        "51014ada68d287b6ba248c62c97c90aa6f034a7e4db3b69fe1b439f257012376"
    sha256 cellar: :any_skip_relocation, ventura:       "654226347993d68254afb986e25c4f35efaccc93151f9123065a5e9bd3dc047a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0271a32975f213335bed1c469211ca614baba175246cde8903dfb54ac8a21b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c14855ac198041da05b3181305c859310da62f2522b13dcc47c0d13512321c"
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