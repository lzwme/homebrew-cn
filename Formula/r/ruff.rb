class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "2135ea2f647a17e9060a3ca10f6df2be9e37ae87c864fe79dd3c067ba6ee57b2"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c395c702728491b25978ac5f7807395f0b46c7776f54c399a60686c39ddaacf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0a1334f98cb5ef2ec82436be40fbb6b047b29b014036b390aacde9b6d7ac599"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43cb3ca012f95f2765549224d602b9ef0cbc74931afe66e21361390de145d91e"
    sha256 cellar: :any_skip_relocation, sonoma:         "84567f3368a9f8ce7d51a78814f96979dc03e34d9eb187fdaa3f9976354b8cc0"
    sha256 cellar: :any_skip_relocation, ventura:        "80cfd4b0797ce075e273f7a62570295726010d1cb4573b199e438ea95d0b27a5"
    sha256 cellar: :any_skip_relocation, monterey:       "440df60f81e8337c09cc8d0976397d3e5233b86bc3e7d003106e52630b7466c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8390e21a2206ae968cf60eb63087cec67d28ae58bd753581e0a6f80153e659"
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