class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.14.10.tar.gz"
  sha256 "9294a2ff12994e710aa01fe37d22159b4d6d45ed309af7a9d10e71ca7313e0b8"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4975f496887e57166d266ae1100b0678990d397e5c707e3a4e29ecd11c1b31da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6abcc9f23902383577360c30e804d22aeff7fec967351d526a28641858c14c40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43ea85bd92882a76bcf05c3a874f1875f1c67e9d49daf574570180adf9716cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "18c3b3b565bf3cb0e8f9d1b4817c0f2abda1a0cf87f69fab767d69d88c592d0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "130563bf03810e7d5e18c343ca7b21042632bedfbce7eee6b2626b3f4caf79e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5ebcf686792840d923c276156fde199404835e7f11ce1a54570c965df856061"
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