class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "06b7cda6ace2e995612f25565c1378282979ac54beb4be40645223f09e5fbdb5"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3787f6797b4c3121f295ad19e651f21ca83fa905864bafa0ba20c40ba845a6d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac017c3e89e6ef79930ead38881623f861ba39936df077409ed61765a07dacb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc9ca383f8f53c0ba1dcf2b3586b31f8873e54acf8e984efc52e81e9fea89938"
    sha256 cellar: :any_skip_relocation, sonoma:        "9685f6033aed9724e5938fa5621a5062b37ebc25c7e97a74c27ac4eec1541367"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56e893200fcfe6bf13d4f953ac489cb142c9aaaf17d02dfaa0ca5cb42b908cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a54bb486f6e0ddba1ae45b06b356bc8ce0d46d670e16bfa4cdc784a2d4a41314"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ralph-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph --version")

    system bin/"ralph", "init", "--backend", "claude"
    assert_path_exists testpath/"ralph.yml"
  end
end