class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.11.4.tar.gz"
  sha256 "e2093c9b62a5ae3b48de7601dad616995d0877b7d6f1c209373bf4e9acfaa24b"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75843374fb9c2ef81211e244af1293226800a7ce729a6ef64bd3ee6dde3a35c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0451aca4a3601c909097b7f1590aac31c40929e4431776c0bdd4a1c4811e068"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eed32114ec971ba19f2716957505f7d71005ed5a0e4a25cbf6fef190f5952304"
    sha256 cellar: :any_skip_relocation, sonoma:        "725f205fd6c49d7edbc0202c326ab4841ff041dd9cec1bc25d146089e1ab2d93"
    sha256 cellar: :any_skip_relocation, ventura:       "4fe51f299b8ea127334f18ede8f81326f1b5b7549648999fad024bbb4e5b23a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "722f617451f275c5062a6905e656719c15cec3aa4fcdc5ad809fa050f801464f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "293675df33ccb36372bef5db9a201fdf073c95cabc985c7c6dc2a4ff96c87bc8"
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