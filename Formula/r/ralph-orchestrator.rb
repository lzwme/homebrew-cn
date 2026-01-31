class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "864a38a93e46cdf6582dbc115792d3f8cb024ec6750ae8a979d02ea4d1fd4070"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19b73bf1b7cdea75893f59acb54c7977f3e5972f608255952b5b27154b3c576e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d6595ed489b22a83c5060adf74721ea14df01c6a2b2173e426b4c9fedfd79c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12670a73e2acc0946033dcec2a8ab442c94806cfe1c46d43b37ca09fb874e732"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f1f6892085ef8149c8c24024080514ef24ba704dbf2d8c7d8540d0e26aa1f79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c505367f2eb2b210edaca5a78805b282252fc9822cf46ec93e979d8c0b4f8d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc9219f0ecf65a10f8a07506cc0a33c182427846e4084319ae8b0a7d7aefd83"
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