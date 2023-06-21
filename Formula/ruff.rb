class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://ghproxy.com/https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.273.tar.gz"
  sha256 "e82cc57cd7013e26b2bab88c27eef5bf9f6189314235f19a82d15ef5771853e8"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a924a8016dabe27e7d8bf5b1b79d611dd2b2025ac26dfea389e06d4da255d097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "456451c014bbafd5642bebeb490e9f79c6e6f884a961206af05f3e0a7670c2b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5fa909f0aae5c09d381523abff12a89b15af54af1628a54dc7ad9bc44865ef6"
    sha256 cellar: :any_skip_relocation, ventura:        "02fe50f270600b4fcd0133a630fa4bf9a2812631c3a2cb1cb7d22e2da4beeaf5"
    sha256 cellar: :any_skip_relocation, monterey:       "f5241462d2c6e51eb743ced456736c4facaff0530f73a223d522a198a4be4252"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9515ba988f7b7729456baacf7a677efe448b9e1f9e173d73b5b4d1ca91cf470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24eca85adbb49bd4f3f363428b903eceb41f171b30a803a197dec2acf64f68a5"
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