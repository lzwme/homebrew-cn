class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.14.2.tar.gz"
  sha256 "f21a3f2669bfa6fa6df80b815e08e39dc245b52b46c156b0e4c7f4f1da32cd59"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ada613f3bf8bc9cbcbdef72ebad51ef7a6cb5634be5253dfe53a4c0947fc431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee5406f4bc1f680f0e1201e0ba0fec342688ce0d1b28f9c6882db27d97f685c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646b31137a5c848e602f91cf077c71c2777943ce3426f29330176ccda7e78507"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7d03215a5528cb32d3a16ff1e4b5a08328287765124cda7ffe156ae98085093"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "130a7c613eec52e8754021a32012cdd09ac017561d03dd8c03878df6c8f06dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86773e4a78e9ec96f92422b259ae4093911cfd54363928a49894b662deac2ffa"
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