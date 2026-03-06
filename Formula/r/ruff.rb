class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.5.tar.gz"
  sha256 "248dece1157347eade855b663ef0eef4b1797e29779c2cce7fc769f51c05c298"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6711848886baa880103208fe8a2cd604cd78efc00ddb49d0a79dcefefbc0b879"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "936b048bb1fd7da9f9d4440ae252126b0ef91089891cbdf60f62b47ce6881151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0be5faa6aedaf1ff3661fffcf269f03bd9a021f77e72eccf04dc2236b9ff59c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d24ebf462901c8362729ee3f9d1f1891b89852abedbf5f84d8838a956485df9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a09a46a2372949e1dfc8b43efb4cb7a2de4745c8b720f49b1106a7bb68a7aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5aa14fba034934213be5b9d958f4526fe03514b154c29a254a35cad6de1c3b9"
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