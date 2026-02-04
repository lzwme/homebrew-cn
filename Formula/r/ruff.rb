class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.0.tar.gz"
  sha256 "4be90e29b1a37b6121044a806a6c41dcb504a6204745aac18c207dc22e0917f2"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5d0c8bcb698f556cf8a88b7682387b4fec2310c512760a0e52c81e92403dd5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c746631a1d814650bf2e9d547eff0dc5a38b90815e9514be3cd67ad8a3ff5f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b589e9498af6c1b12d4ffb2e218230a40193f1f238e3105e9558808a40d5096"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc84a0ae28a68d33f49426277f9753241be5c3cb27b97d45f915d7e296426743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0b45c442e292c507d3365b71195317dc24d22cb897364bc67361e79e506925f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39e79ce27c190693465f509bf6112c631f3039ad5e71bd5bc7623bb18315a8d"
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