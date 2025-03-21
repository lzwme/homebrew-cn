class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.11.1.tar.gz"
  sha256 "3ce15169ef66190e6d8a1c0c2436b25a0af2826f0eda56139f6a7a81b068e987"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b9882fbd068b555b27618d49b26f7b9f12f74a614be41e0422e3c13d828ad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9170ec541ec579be409d497150c0beb288c9d67cefe54adc3c36132616bad41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "547cc57826143a3d94c0d67a6f0f051403222ae3b1d62262983ad91ab26c36b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "737f49916e83af55719412adcbbf476ca735147b894a2c439411df7e0c488e59"
    sha256 cellar: :any_skip_relocation, ventura:       "2901c1f6607b8058fe593a8249309e4623eae5dad400da46f3bf20746443b0ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1babb5d99d706eaccf57de1658f8d4c0684110e60554756d6a3f612452db8bd"
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