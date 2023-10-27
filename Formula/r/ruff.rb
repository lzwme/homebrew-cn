class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "448936202951954870293450abd34868ed40aba0af7775274e0b57fc6a061661"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "413195331274e6f04e68b92476d44998b78b8183ba394153e6c09f5d23964066"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88305cec38d181b9e2a52925e7b94b8d5b17b1c752a0e09ff942c788d86c8304"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cfaaa73d5f1de11cc0b936b1d4742be4ed072df82b862dc6d407a662dc717f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a66989bd7ba8f63e4cdcef22f22353ab7cf1bfc2de57c593e45e78633af1031e"
    sha256 cellar: :any_skip_relocation, ventura:        "11aea5e09a413155c87389fdcdb2558cbe6c563e90afc2a75abe304bd0e5e1f0"
    sha256 cellar: :any_skip_relocation, monterey:       "c789f2ba3efd2469ac9b52e9d6f60144eccbcf3e601bfe51a1648a82fddd3a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb0faf9cf97ce0fad2a9b5e855064fa9acb0f981dbec59b8bd5d09be8745d04f"
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