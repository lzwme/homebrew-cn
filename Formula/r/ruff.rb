class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.1.13.tar.gz"
  sha256 "36a32001c821b844d19fc3d95d6d9265b9ef03b08c5e0950dfa94191454b5a93"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca575f9c5b199a8fb0c2df5512ebbb714e608330ca9a589db03b95cc6e763b67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2904279d061beac877c66951809b7a36760de5fff6a427ddad321c9d2a513a90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b2b166c8f88d8e029781ede72669d87a1f7c59b05b7189832f03816d7f153b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec4259fa4510db795ba8bed6706acb3c9e238e65e29e0fe51c32836176ff340b"
    sha256 cellar: :any_skip_relocation, ventura:        "de427053a0b4819bb5c359c3242b77e9ea1bfa6098e4a7b5094e0b5fe3b165b1"
    sha256 cellar: :any_skip_relocation, monterey:       "03c7264f00f4f03e025d4bf7d75d0ee37f97dff8084e23f8ea0357211a40892a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f5db8380935a26913c87e0369f3235a141da11d50aad16213e0d713cd75ffc3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesruff_cli")
    generate_completions_from_executable(bin"ruff", "generate-shell-completion")
  end

  test do
    (testpath"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}ruff --quiet #{testpath}test.py", 1)
  end
end