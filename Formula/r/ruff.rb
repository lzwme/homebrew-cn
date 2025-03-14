class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.10.0.tar.gz"
  sha256 "5daefd48e2c0b4de5e5f3f2187ff06d87626ba0bbcdbd58c269fedcf22dd4cc5"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7e22df7cb8e4f855fd4f2484da5307314c5c32dd3c03effc07723c86449ae8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d87220589eccfc11416db0e2efd4960f3d36ed81a5003c1592aaa2c392b792c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53a3a8adef4e96927e173e817539e457d6cff0eb6467558dbb9bbe08162cfbe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4987953f3415d8202e56de5efce2f9bab3477a0d0c55d292a48f25f8807f4426"
    sha256 cellar: :any_skip_relocation, ventura:       "74b58c27609588fe83796a7a9f5afc41f4259c3ffb472bb643100b394b115e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69572e0413c75496a801385d27b0ea48423fbb88e445b9c32ef92b3700f034df"
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