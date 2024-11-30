class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.8.1.tar.gz"
  sha256 "2357a0b0034ccfd16146c102b3c4ce652996e16be26499d2b6168c065b58c8d4"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e13ef8bae4c73db0656da88d696435d4e64d04ba2fa573f92729b8f4010c8d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4208f8f1129e408064763cde0791055e4c0f9d1c256d8e9bb44d55bc5edce2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5062a3d9c2080c327b64069a476a2ada28f6fa8b39d4a46ffd05873839504f98"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c13c1cdc1d78e99f729af871baf8273e63db3c8cca7e85ea0db9a22ab983472"
    sha256 cellar: :any_skip_relocation, ventura:       "ef1bcbe063314f1deca83046cad7e6f696ab9ea70b5be2febe06188560f88917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faca5964fe0493c698bc5c32a95e2b9fae2fd77677e16a450a7c07ce39c80560"
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