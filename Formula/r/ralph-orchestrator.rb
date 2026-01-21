class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "6a0defdc2479753ea5dd6dfdee102560c9a00b8188baaa2504c0965375b7296f"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83825db14072ddcee7433af69ed99f2cfacdfd9be33f9fc55c9a1928345a5c51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "633ff80f039e42065befe0db33b7ccf5e5094135809922b20416d9f6e7dbf20c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "232e02d95525341ff06e9ee0287262c273bdb3d11d39785df98a24e6067504d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "74f48397f1f6812afe2acd18052787aa13df4d45d46b9c9b611740297edb7072"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "493f15f9c6b585f8b0b97b0f7a659c41f2e9c8188e1f3d4c91863ffbf6c5e7e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "744489e4bbc81456125e17542562cbf22d686f39de497e5cc26129a75d60c67c"
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