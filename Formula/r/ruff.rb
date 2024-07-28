class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.5.5.tar.gz"
  sha256 "b0f710015cc27c58f3b7236d493f62d4141efaa37b49abdbd79f21c63d58ab41"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "869c0b903663beb2bd340b0d2f2b2e18ccc6b7795de0056b49582bf3a3d339ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71176da87774f2a7c4c99539410aebd53d93924f2267cf048bf91d4c3e232041"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3501416229bf7fb96eac0d6dc57bf63020fe2e1a8eceb17b6e5df6259d4872cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c2e8d04592bddb33943d08bf8314a201129ca6f4e93337118e5665f2e1ad4d7"
    sha256 cellar: :any_skip_relocation, ventura:        "07e8245b6e454cbbf04cefe8c4381a2591f1cc0a61ff845bd1d0b6442af829cd"
    sha256 cellar: :any_skip_relocation, monterey:       "5c039ec779c140c2294be051aab7ba79bf18cbbd09aa4d671bdd846a8ab4b8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89ccec7feb989fd412f92275ce3b05b552e08e71b515cf62eeec32a8e1d40dc8"
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