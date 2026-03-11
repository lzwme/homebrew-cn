class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "b967ff16313d90f5f24b9ea48ee82895de0a59462cf615747bffc2dcfa5f78cd"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4dff10dd9f0dcece5244775bae27c99d243ec467833369255bc555510c95aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eb366e0f786b4b9f65c86b3e93d16e0412ff677fb7d277e8d4f8d0094d2e31a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "975d195005c663082e9ffa8b0fafb499d7451874bf95316aa6896b9cda831034"
    sha256 cellar: :any_skip_relocation, sonoma:        "232bea24f01efab4c2062d772f8ce19768125cf167ce9a64e6e73e3c8436430b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9250e5323fbceee56ed91130cd4949d2dc46d7eeccd76236287eb10929dd7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c49f1bc0650b22f01809af673efbcdf3f3f915f0ccfdac369c9de32b03e290a"
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