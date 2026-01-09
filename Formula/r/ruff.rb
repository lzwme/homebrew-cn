class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.14.11.tar.gz"
  sha256 "391386261e2dbc62877fb3c8c37a5d36dca6f6d1b34e2a96d5fe9fa2bd4ab5dd"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6354c7e44c2c4f10295a09ec9919e0770886790e4621dbe93292588515943f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c53ca65451faf57d5bc2e5fc7691a120d2711543f3aa4cfb4ed2ae0f05ef72f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9976f9f4e001f977c2e83476201ee8fad3e38516c987522e0f2128da905a4387"
    sha256 cellar: :any_skip_relocation, sonoma:        "2073c577d7ebdfac55805090bc56c90e06185d7366ea5c0f08e9bf845c326ab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8483ff4226bcdbfb8c5085534e997573621d515abf914992c40bca3a5538c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5854aaf2a5ca1912634474c7632c0f82e44001e77ac69a0ac1a6fccd622b9969"
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