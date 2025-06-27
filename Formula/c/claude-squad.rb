class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https:smtg-ai.github.ioclaude-squad"
  url "https:github.comsmtg-aiclaude-squadarchiverefstagsv1.0.7.tar.gz"
  sha256 "3dd3645ef175ce87f00227e6c2014592d11e764218e9beb86973ccee57a67ad4"
  license "AGPL-3.0-only"
  head "https:github.comsmtg-aiclaude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe712cc3be008b8d012e5955d9d2427620f2838808a58945f08a401974e1e1b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe712cc3be008b8d012e5955d9d2427620f2838808a58945f08a401974e1e1b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe712cc3be008b8d012e5955d9d2427620f2838808a58945f08a401974e1e1b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d575b578990779da2668e755be1207550ec3aa47a34df21fb64c2c054334bc8a"
    sha256 cellar: :any_skip_relocation, ventura:       "d575b578990779da2668e755be1207550ec3aa47a34df21fb64c2c054334bc8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9104ee1bfdf0205766ee85dc264d1b4b5b12a683e08d17449f75b3732228c584"
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