class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "1c7e688613e699be77e2e2fca61699107f0c794b810c4f13e8180b9f12fb23d6"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6091d65d8badcb034c49fe2eb5c00093332044745f253e56d88baccb964822d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97676861377f867ea2772dd68d723369e2ccbdd064c9e859ce58df4b83f0d090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f4fd29db8b1121a061e9f58d52f4ddf7b44069ed99d32784fc368daa7d5aafc"
    sha256 cellar: :any_skip_relocation, sonoma:        "70c79d9bc75e91093846e51842f0e2cc13211aad51d90bea7566ca0d0bde6b48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "961663045d9696fd047cca5a30d680b60073ef7bf9a0065a2306feb93a403f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a35d93041ef57a9fd348a6618ed5a570491ad6d592ee77c0a3c1365a5076489"
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