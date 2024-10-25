class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.7.1.tar.gz"
  sha256 "2ff2f5e44a0dd8ac8244ea28a53d96fc00ffb62cbb970a6dbba7ce7b0b268eb4"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f1546f66cb73351332e4aa3406e4e51f195446797b1876392f2c48e0aac4297"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f4eb67da6271a61da2aa809c183239ee68d6db78f495cbb33823e7765eb7c1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fce3e68e1b3c8b20a6f964f726713caa0ed58300a0b28246fb9a94a3f9723f87"
    sha256 cellar: :any_skip_relocation, sonoma:        "62bff9637cd6671e37e29e2fef0e8b58311b53bc63231675060b07ea50e2b17e"
    sha256 cellar: :any_skip_relocation, ventura:       "8ccfa9b34118734c23e5226f8b88ca9ac9ea6a37dffa64354bd3e9cfb48bd04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4a19cfa7533da7d9cc16d9aaefcb060d3411b2ea0d483b68446bc78b8f550c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesruff")
    generate_completions_from_executable(bin"ruff", "generate-shell-completion")
  end

  test do
    (testpath"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}ruff check #{testpath}test.py", 1)
  end
end