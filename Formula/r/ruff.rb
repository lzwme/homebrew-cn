class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.9.9.tar.gz"
  sha256 "700561abc69eefbb5fa6a61cada7b4d3e1510004bc0783ace9bfea316a65a1e6"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbe28ae4c278b775192ad752133e966f099e17e3948b92389a5fa6f2668ef0aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "068bd30a166358359a5ea4b311d227bfb2fed29fb35ed8dde7e9a4033be4baf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80aa38a5fd86fc9fa381ef1fddf3bd92d8ff82cfb82ff05384732bc4c1f44e85"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c40b3595aea4f7472b085b56084c9f72a4ffa2bc8411ffcb42b670a6c5fb43"
    sha256 cellar: :any_skip_relocation, ventura:       "52d7c8bc906a29ed622dba33bc9aaec535eaee258c1550eae4e1143f49cf8da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2400fb1f5dbc8607dfb1d832812519ab0228a77357f185a5ee4b6f5c33b471f2"
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