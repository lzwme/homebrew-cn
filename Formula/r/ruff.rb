class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.9.7.tar.gz"
  sha256 "24ef03e8a5421f59f238e97724ca89be34fda74efbaa69d4cca9f38ed3389596"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47c9ee78674706221515da62ceea46013fe41cb9a8cef74e4b18f724a9180fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23a10ec7a50a2525916dad713dfb29a3b95f9ca4a21c2cb5ba31216b2032740a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6a22a97bbbfcc6d8a64e423e8a3762090fe554355a5f1518bcb99b7438b2436"
    sha256 cellar: :any_skip_relocation, sonoma:        "87593579e593df9ba65054c1475d02ee7a488e3cf6a72d750f49f588db67d705"
    sha256 cellar: :any_skip_relocation, ventura:       "b8cf34ce012295617a67d25d1355249840f747e8a78fa7942c0729a3fe476a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68ffbbce6cc2afce9f15289256a3f382550492698975e9b011c59f0c2513d0d"
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