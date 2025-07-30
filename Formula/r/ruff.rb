class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.12.7.tar.gz"
  sha256 "b759737acad4ff5c26f214595b903316892c34606e46485a9447d020739b2ee6"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24e911c6a4deeb448527007aa947fde67cd79a8f41deeed0c7f9947fa7752f31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8df14dabb60c5ce81fcd8c1fcd76fc4c09db781b9879cd7fb57c81a3a4a9bb69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30f8d840fb985ab9bddda82a644bafd067d36b9ee589c31ca19e5e24fc834e7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b10700a6f7bbd939f7958ac0b13cac5128e97ad6410677d0f7e91fcbae105c6"
    sha256 cellar: :any_skip_relocation, ventura:       "4076b79fda4e56587a68f0c3913d63aad73964f46a986abf9927c5035f6c8fe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2692e56f5a1572761d7d7863370003071579259eff89c10472859d226cd29e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dac0766978f20245e2419b1789209f92fe9929c955e3db82f80dc2365dfd07f6"
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