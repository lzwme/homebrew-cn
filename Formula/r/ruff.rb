class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.8.4.tar.gz"
  sha256 "f48c9e2479e72957ce5dfd3d0cc9d27f5aeb36d15ae2f97c9c116fc5c742dc5d"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "736a9f3e6d1f8afdd3213af48a50d7a4464dc70594651e3151defdab7788e12d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a92276688d6738323c9a0fef2876b3a6588703462c84b19798a7261311830fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "434970855642b8f736e072db5af8ee36b76c3c8e149f52f212a8331e10cf5246"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c39b75c2f6353229dc8b4e1c591099358a4bd69f08a73e19282b112f85ea68d"
    sha256 cellar: :any_skip_relocation, ventura:       "7736a25c660636174ac0ca522365e9e717bee2351ad60543e62a15f9e03f3c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53d4cb7c5151ca49f37db6c1a4cc73aa75a033836ee12bbd34b119634e735fdc"
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