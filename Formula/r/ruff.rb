class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.16.3.tar.gz"
  sha256 "1eecc23082f91b6b2ad3be2b608bd4ba02d04d8ab519996134d5949bf4e238bb"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d64cb14fb1c4d9a70fd3597d617baed77466c96508ae6dcb39d9b859531a5c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60472b8a526928b37e2a76657de829479b192a5f8cd5cf95463ad4bba825c2b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a562863e45df508728ecd2189daf1a4c66b079579f4d899aecf0b31a35ae1f62"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee52c9f21a5588d160a4f644d39e8e09a9db9afee67c466fa8bca94898f6a6f"
    sha256 cellar: :any,                 arm64_linux:   "7fd3cd4c65442e4fd754e860746b23bc342156ce6227a835632dbd75bc926741"
    sha256 cellar: :any,                 x86_64_linux:  "0f0b7ac2f3de580ed0868339ec15667e77a16db5abe6a30e1ebda825a4342441"
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