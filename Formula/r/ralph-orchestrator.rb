class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3088373ddf5e22397b42f158e47a753ada488f8d225f594f660fc224e074e6dd"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69feefb987e1bbf9574ab7774151460e13e29e4fbe361f16123f0eaeefe5d2f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8bbebb4d078973cf720981c3f502b5d87024709f0b3c93f3c16ef33ed1b7cbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d929002abd4a58e63763fbac712e8122c5b6d4a64f5bf5cf1b6c5256c0ec8168"
    sha256 cellar: :any_skip_relocation, sonoma:        "5df0b0fc8e8070619b7e3a73e5547be435e49aee403e881f498ca5c8ef2f1e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce811c0ff976aea17af7c4d6a87c303dfa3813a86e322153e833c8d3ed887eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94c986e31483fe4cd9619952edb611cf0cbdc0ad9e886df9a3897538cf920545"
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