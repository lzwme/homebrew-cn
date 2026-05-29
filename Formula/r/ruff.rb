class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.15.tar.gz"
  sha256 "c3feaeb38f401ae1361fa182876385c398a674ccf8739651c70c34dc8b181946"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08baa0107ba1b9ffb7ceb1bb2fd801150a4e07256ec8d5010f74a4659fcadd34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcda9a12e17aae79e288abd7b8599f0809b55b482316dcdaef477998e3a76d31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c95239ab0dc95846f2792f67529cf491b1628424d4be2584c3d34cc19eb3c87"
    sha256 cellar: :any_skip_relocation, sonoma:        "f542752120bbff81ec0be77e3256c297e8d6dff797a86058e4c4c11672ff2a49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffe9ccdc1e0b79df973708a06b5a1c0f3224786617b9e6029d355f2461dad589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bc9df65821d01c865f22667cc8656804fbfce886a42bc779f6731496f45cfb4"
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