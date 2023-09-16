class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.290.tar.gz"
  sha256 "f3be03d9594ded6500b29bc0811c37a2270bbb60a1bbd527a2926e49649966a3"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f111e831618d2f57d9d465ed98b178f2034c267dda8204713477888e8c03b56d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d56fd2340b4b18e1ff9c53bed7a28c55bd58b1008f346457b0faa21050d41c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e8bc49d0c9fd0628f7222bce6afb186762775dbf4360695aba5519102e43216"
    sha256 cellar: :any_skip_relocation, ventura:        "f9cf6137a1b48cb9d1bde9ca7e28b9c7f57833b31bd01cc98fe80902775ad875"
    sha256 cellar: :any_skip_relocation, monterey:       "45b6b494d544e4da9719fb6e56e6d958e6f1b24a5a6724e28dde1b2d51923fe8"
    sha256 cellar: :any_skip_relocation, big_sur:        "28cea805e9da6d6eb93a7975de25af61b1929a6b435f93bc3068e2d40c04564b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b51c7d605d46321f0c4c25b931d2ea093aa88abf31dc3593375fab711205cad9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end