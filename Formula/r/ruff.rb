class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.17.tar.gz"
  sha256 "7a33ac5e9fd96ee3f2d7939dc4b9393ee42e9faf6a4c7956c11874487be64eef"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "675f8b286f3f359b3269a21caaceb17238604d43cedfb2668ab39faf976db5fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01addca2a502c08f590388e4a25fe618bd7ba6aaeab9249c7cd34db9e1835219"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96f5eaf32bd1d8bd9dec4ecd2941565fd112a168a545770fe50e68c6a3d9320a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a903bfc24dfff3557c0d584b230919b5613e92a9264578d4aeaaf8684cfbe0d"
    sha256 cellar: :any,                 arm64_linux:   "9d018d64189c9ea0244259bda9f78e5ba73a00d06ef8298a53298387c8917f5e"
    sha256 cellar: :any,                 x86_64_linux:  "a500e8623f7794445ec8f4a6ba538cb8e11683f7b2d5f2f329d3a18ecd50b923"
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