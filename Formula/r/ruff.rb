class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.6.tar.gz"
  sha256 "98197d22d940f7c62349ed9a683937ba75e03990ad094bb8ae0004eae37cfc30"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a6fc57ce0491558c9425235d092ab6e89c91cb147f94c767c76996ac32cabe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5189dc2d8779b033e3394efc5333b1bb0a6b784147fcc1eeadd699f28e895ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba0cc7ad239e513ed20298201b9681112347a4136a6cd3adb99073c60bc6874"
    sha256 cellar: :any_skip_relocation, sonoma:        "62adadfcd01fb774104b5a0f2029a19d69ad3b2fd90fdc5d7638a3ebb4de7e23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da87449cc8ecbb01c6ca2bfca768bac51a1c566510e1c2494404618a4ad4d1e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3bff77ea800d94b9f46caf2fe636c6f7961d6a29d3b50c4105b7aefc821d7c5"
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