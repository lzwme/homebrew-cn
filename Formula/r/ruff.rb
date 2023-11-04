class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "5ae15d930ae5251eb5fdb271c8f17041f1d5bd277c4d27d9dac7eaa0542d91ec"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61cb745ce47512414ddece9310f20aa1df26c2ece8aa63332cf306e7c9996994"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b312c8770ec845639cecd3f5c3ce9ca02f794573e20b026a22635bc17d2608bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40640be075bf55c9610b9458f3f28d89b9d6eeee02946b82ea619adb30b48b54"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecfa164b4f150d0949dbf23d5f42f8ccce8c775e790a804128f821c1aa5cda65"
    sha256 cellar: :any_skip_relocation, ventura:        "88ec9dcc92a00d722a1bb6c2631ab4b2aa76600f853259fd1d81fdc954371568"
    sha256 cellar: :any_skip_relocation, monterey:       "d664ff336268a42505a74a0677582f958bbf3848fa35452eff40cb8558f11f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87580cc8e228bb0c323032975e068dd4b3bd56223ddf972dca4424a13c98cafa"
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