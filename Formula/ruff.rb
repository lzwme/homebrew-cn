class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://ghproxy.com/https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.258.tar.gz"
  sha256 "09d5f18fdfd096d3a1396e70bc0e267c5e79036a0dd21c631aab626c2b15ef1c"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ca586615fef3b5ac16ded12024df598e2bcf7f8f98118e804c8aa1f77dbbf6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aab6a0d31bbc62c6b57101539c3a46f21a857705169f925ee4ac0de3d1906a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69f4641ae9220a088fde5b0aed2614cc0c8235870db6b6808906bd8b1473d94e"
    sha256 cellar: :any_skip_relocation, ventura:        "f47b02f885e93388fec7b5a70dea1a065820e51cddc4de1208b59648d63a9e74"
    sha256 cellar: :any_skip_relocation, monterey:       "e5e5bd2bcafc820ddb602f57e0c675f4da661756a65c033d4de573066c9db571"
    sha256 cellar: :any_skip_relocation, big_sur:        "d21702543b464980fb53d7d7d1de318cd3486edb9a6ee7d9383dcc5965224481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9120d4efd6bbc48cff82ad361d31364816347af0d7ed51aeea071ad9fd606fdc"
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