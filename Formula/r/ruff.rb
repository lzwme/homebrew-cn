class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.12.12.tar.gz"
  sha256 "1f8a913b26015aba801b5be14089b2730d3618a298d2d9949178eb3985346feb"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e418c4971de3b689cfd4eec39f9422b22d7889a87e0583e775a9613522c008b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95a5e57d5a57fe1fa8a36ae11d4bf9b9477e0c7f9bfa78c0c7a94b1322fe2f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e2ee34a36c4bcb3ec921ce45beeea05600c39d922ec692250bd01e2376848a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3ed4014a8b0c8038af89c74d13535d36ab5702183bfab0d7ef62df040f9f3fc"
    sha256 cellar: :any_skip_relocation, ventura:       "f299b647292a9f0bae8ddb12935683d081a2e6338c3c4d6ca7464ead972b1165"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b8a009461cd93b417ed1c46a25712067daaaf0f5646fd7e4d297e947cf2c2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc5b7b25c27715db23c098bf2cc087e05959e7bf828cd9e629dd26de85f4507"
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