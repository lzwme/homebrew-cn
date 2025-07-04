class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.12.2.tar.gz"
  sha256 "e202f6c12e13d95599a146c81d5f58a17544df08d93ba2c730150785dfad45c4"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f79a1240be8c5121420ad3d149ef01f1150f23589e2fed5e54dd922bf9f8dbe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e4c7bf64db36ba712d3035a4ee22b5ed98dcaae1d0bc7082a252bd42cd68a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adb80e2b9f10f2ed3c7ca9e4a6678d2cc418499181f7774d2af66398e8cb6620"
    sha256 cellar: :any_skip_relocation, sonoma:        "a769f59256bd138e850a94b8ad9ebdbb2a71cb847cd71203637f073b609207fa"
    sha256 cellar: :any_skip_relocation, ventura:       "e1e6481b540dfa25b0723d1e80ce42eed76c4468d8c748c6ff88a9e3a5070886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80d9defb823de45a5cc36a7eb3adf544b9d3faba68580daee81f20210ccf2736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7626904b030f3829c13e6f2da7d9d4e71c600c9c1daabc6ec654fc83969de257"
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