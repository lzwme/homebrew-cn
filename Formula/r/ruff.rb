class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.11.3.tar.gz"
  sha256 "cd83fb7cef3c1df350e037fb6d183f29c7567048e1664159cc72c4d76bef9331"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e18ce0ea820c3edb11612a3463190bf9af13e74e3eaf6ff8940ef8a02befdff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c73b8f462176d6b2cfd1f0dab7f10432b9a2710f42ee7ec9e4942c5a1c8ccd7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80f42766c7572988f35fc2bd410f7a8110c75c9c78dfc19cfdf6691925db7ea5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9384fae3527959029ac8e8cb62948ee094bc89e2ecf6e641aabb107f292fc742"
    sha256 cellar: :any_skip_relocation, ventura:       "0f54e553c0bfd47dc663a4333a7fa0f3edd0e09a99a79695c2820c5c828d537d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d4a933ec2b3952e42ed91755492074ddef17b592d1fc6ca39ebf72378cc723f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6908f53b7489ff9d8eada45e8f322e6a8dbec2c9742263a83ec591b2cc35495"
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