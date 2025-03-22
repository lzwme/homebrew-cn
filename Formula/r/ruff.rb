class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.11.2.tar.gz"
  sha256 "6c70936b6ce7b8efc2da44425dc47a5b6941f6050c8d3fd2d617b7c4b8efe02f"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69ef8d928c3cc699ff04aced530fb0c22af2410b6a36c872c8de0d3995ef64db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c427a23a74f470a13ff2435cba61f314026efe903e93bc0b73145cabb0ec6b94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "686e3f40cf89199c0d74d2226778f9dc05263633a662c211bfba24e43dbdb003"
    sha256 cellar: :any_skip_relocation, sonoma:        "081cbe1f54fceaef93b39c472f70df37d040998c7216ac8e0176dd8590639963"
    sha256 cellar: :any_skip_relocation, ventura:       "ec23a4bb3e034236a4c116736d5c2cfb7440833d1ba62e95c6da854df502a872"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c6de11ecf1febe06783ed832883a2302d7f5732c240645c6e698fbe3f88bbfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cfe96b414f4a2319a881a16f240bb3d9de1b1ad6aa23d1962dfc71cca0f0ba4"
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