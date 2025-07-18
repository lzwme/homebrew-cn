class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.12.4.tar.gz"
  sha256 "7b543b99cd9e5e6b0969e5a1c28ee19e1ad147914da7cbb52ad0a77fa9662dd0"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60ede94c70d0059631d6b829f2c5acb993f4fcb6e3aceee3a0d8fda2d180e8d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbe00013ba6efcb78118974ebbb1b17030e364d22dc371bae6ddde71e85def8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c48573445a02a29665336e7577ccf6b7c284b1709247ed411859421b9bb245e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a877d95458434c5db6c658acfe7e0dd5794eb7dba0bd5dfa8a46a213b3044e3"
    sha256 cellar: :any_skip_relocation, ventura:       "b1318362400ad63cddbe0c8a1ac043186ec65644178aba2cc1284f53bd879ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdb0696071915007b6a04c6171a448aa905126b1e895e961e5ffc80e78fed7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4ab45bc0f4d72bcbd56dde50bd9922409905a0b42fee8cddea7c664bc42ccbf"
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