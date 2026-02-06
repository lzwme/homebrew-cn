class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "356364d3cf7a8357cc29e0a2aa6a2923875cb3b544b9d361f37b36aff4235d5b"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da792a003282b66d0bdc10b1895048475375ab01d31603e7a4d76897996ea75b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68a5032efddee3bad6e18584d851646ffc2983289ab0eb42199290413d036323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "218a20d4425befb45adac53ecdfcff94d2065a9ab54627b4dc77eb8e20259e16"
    sha256 cellar: :any_skip_relocation, sonoma:        "a96ddbf27d17c07217307d42163fed45978c4ae6bea0632f5016f70f6318825f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9727e8ab175a24e6403036f29f9eaa330e79195588cdf6af67a672cf12be6286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f97bc6c40faca6997d75987bd7def7472676174a6ada740d94b78abecacfeed"
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