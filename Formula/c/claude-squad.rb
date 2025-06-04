class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https:smtg-ai.github.ioclaude-squad"
  url "https:github.comsmtg-aiclaude-squadarchiverefstagsv1.0.3.tar.gz"
  sha256 "d790acb3d3ad80fdcd73be1200b6548367fde4abf39168d3d85a772bad0e84f6"
  license "AGPL-3.0-only"
  head "https:github.comsmtg-aiclaude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abf592d9a27f321cc6654eeba356d98f164de9c1345dd6b28d45eafcd683739e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf592d9a27f321cc6654eeba356d98f164de9c1345dd6b28d45eafcd683739e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abf592d9a27f321cc6654eeba356d98f164de9c1345dd6b28d45eafcd683739e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a1b902a8120cb20125cb483ae698ba096f57c0ba3d4616bdc9a4064ed8c3471"
    sha256 cellar: :any_skip_relocation, ventura:       "0a1b902a8120cb20125cb483ae698ba096f57c0ba3d4616bdc9a4064ed8c3471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec66bbab559e3a66c78cb20994f2b8412624ea8787f030b2686c05ce3953712e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"claude-squad", "completion")
  end

  test do
    output = shell_output(bin"claude-squad")
    assert_includes output, "claude-squad must be run from within a git repository"
  end
end