class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.9.tar.gz"
  sha256 "c3ae08e55f6822909f590e733bfd912c489027139c5f083e35d67afc197a15f3"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8be2315d3d4825437a2b304cd794119500a477051bc2ff15cdb1f83cfda1baef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de2827cadaef5e3194554dcb975ebc29da23dc66f52fee022c3cca188650d7d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a89e0aabcbe655f898f60efee68fc10043a62843f9c3de2137df06db7a300d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "eac50bd46960cd7b7d9c69916cd3d7105eb077a023f5185f5d8a1b8e9de648cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b52702d300cf82e99470f8bb4628d350c9fd54ae371b2a5de6da351d9a14b1aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1102502541abdf96ec404bf50fbf753f9c0acce82a5230d5bdbf0db66667b168"
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