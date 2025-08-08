class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.12.8.tar.gz"
  sha256 "09a56afc9603b8f72bffc57c483d3fad872215ce5a4b0a6e4b67fb562ebc5f3f"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48e831edc5a173608a4ee0693d1c07b4a1b66f2cd9f6ee231934b6e1b4ff68b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f93ff10b75a071f6314e240ba030782ddbcdc247ee1833d9dd5b983a4aa42325"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f897c299397a190f7c5afaebbed98e9e60a0218f5c6051e3a6be70c09d5eb29"
    sha256 cellar: :any_skip_relocation, sonoma:        "711b4a05f4c93f0ad0238771255989c8d411fcf695e3d48b2dc8046ffea98775"
    sha256 cellar: :any_skip_relocation, ventura:       "f8ec0b8b6846b5e9bbe9e145ec8992fbcaef420c49e0c1cfddba481e9f7d252e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44e187a49ea7f8393cb13f85d43678cdc65c12c0c9d912ec8a45c3d63258c905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "557df5248c0794fef6dbb1f2a62745ab3e1ec4fdf525a1006ee3a7b0d0b71ea2"
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