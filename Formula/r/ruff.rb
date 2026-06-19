class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.18.tar.gz"
  sha256 "b5360d8b6d27895b65b2c15ce8821951aacd4180606742fbf8857413dd3c1886"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb311cb558bccad8b0302cbd9a448edc3acfd78d5140d77ea66408ea2e7fa7df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "165cfdf8251d80d2e4272a00b61054a603170464c1f3124288174092e76910d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00587ac691c555f6a07270b07e2d328840ddc882cd1cd48753eb9508a752815"
    sha256 cellar: :any_skip_relocation, sonoma:        "16aefd6690723197130dd64cc560223a8537be41d35230b5b5562678b1243404"
    sha256 cellar: :any,                 arm64_linux:   "70205306a76f6e7ca1f4515fddf4755d99e81d7b4cb97a180333794a62b0a609"
    sha256 cellar: :any,                 x86_64_linux:  "8466638143fc29643fc76a02c07a84cc03af437c0c734dd7e59743b828cf1e31"
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