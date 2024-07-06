class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.5.1.tar.gz"
  sha256 "4e31c38d800601cb13349cb9c6b29cd0a37bb505e467abb4492a1ae255eb5a48"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aadda397c32311d163f5d76b40fd478fe3e19c62a00d13b41aecc1cc0d265858"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e126e099b49a866aac3d6615d9d76e190c478d44d1e302767f0aaf82d4113a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fc3c2d550a29dae29db6e6b07ffe453a041863938074b59e9a6417bfc8bc58b"
    sha256 cellar: :any_skip_relocation, sonoma:         "594d976c57e13cd3682faadab8d3427f9d25779379ebe4d888c923dde3634b6f"
    sha256 cellar: :any_skip_relocation, ventura:        "1cbac9303831c2428edebcebf1218fa2bd5a935868e3877ed77fbf3b92d883c4"
    sha256 cellar: :any_skip_relocation, monterey:       "99d2a2af2f05bc54b915b879fa84cdad68bf97c40cc2c1b0ef1cbea3ad8ff4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "173bf05ff5347f93def4d0a5687c8436063ab9d23fa2234c13df628adffcaf0f"
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