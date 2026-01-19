class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "a02278bd950200d9c957af8ed740276e401ffc1be5e3972751f3a7cb557bddf8"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3004eb1727cf19248dcc4cd9a8700f644ed4c1a8f7637aee98ca249c47f7a60f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f73d680eb3848f42ed134ef233303e0acda463702dd7290f065a386e86bb26ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b554a24542b58b863a83021aa6f97ca744bea3645e18094fa3efad47c9782e3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa0094e7bd794ea17fd3abe8f3c4350e3846d67b09240bfcfd7b036473a3af88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a241ddbfad312b32394e35e0353c31084fdd2d116fb567014420861f8bbfa86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41c41e8a5c4f439f2eddf8f0410590ec9feb73c7ea0db01c5e0bdf67b71bcf64"
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