class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "7a96218004e1f7e4b79c213c69912bfb7e6d795a61264de5a6856a28b63096de"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14ac07d3025cd524cb44eb25268b3bee1958b0bf2f4ea81a746362ea052c4a85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aa3e70147cae434958bee587a158aec5f0eb8e5415cfa0fddee2c7c6ebc72e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "884fff229335acdf0e56ae61f907e194b5131f1d4833da6ae67d05bab812f903"
    sha256 cellar: :any_skip_relocation, sonoma:        "c25d5f41350c8c70c4e636af0f63c6a8c74ee25ba70f17625b212b4688aeede4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3e02ccdf2025c9a4e8429fe20fbb09bc17d7d9dd83acece2b85707f569ed588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffa7b5d05858f387d55879bda16ef8d56a46f8f755aecdae2089f10af828c3bd"
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