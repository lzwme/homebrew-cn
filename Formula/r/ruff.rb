class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.2.tar.gz"
  sha256 "0934e0298855317eb430244cff63ff249a949caf499761d96ba9f2d37715b663"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bef2b3a016f7c02684ce32e88f230e600e482e74b94f97692b0a1911bf48a389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faf0d8c3bf2d6e7b50df2ae2679d3c15c6fa44cb24125be556ddcab23741ece3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5208d03428a655622e88482828dac7ef39c138f49a4ddd322040c69679e4833"
    sha256 cellar: :any_skip_relocation, sonoma:        "3296b22bd401752b820c22155bdcd98f7fe1a7d207c9007a60c845e26685d551"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73add2e6c8a7caf61d904fc508d85ccdcc98062f94a950d4279840f5aef25149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22713a889b8b32fe42a5840903066b7dfc1587e569c23c69ac7b32a88e8deb03"
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