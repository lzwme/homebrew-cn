class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://ghfast.top/https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "01155ad6a3e6f955402ae744683cfc5f22f2bb29e8f5b70e6d14e98dde36e9df"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb7c43e74a67ce9cec8a513fa9962827ddec0ce374d401426da21f41a7453fc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb7c43e74a67ce9cec8a513fa9962827ddec0ce374d401426da21f41a7453fc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb7c43e74a67ce9cec8a513fa9962827ddec0ce374d401426da21f41a7453fc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "75054f430e8d934d163aa30c940739fc56c8fd88f027f167ed59ee77bc3761de"
    sha256 cellar: :any_skip_relocation, ventura:       "75054f430e8d934d163aa30c940739fc56c8fd88f027f167ed59ee77bc3761de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ddcd0db64af3c7e560269d4e2fdc7340092b3162423f445d2d8f6a632721bab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"claude-squad", "completion")
  end

  test do
    output = shell_output(bin/"claude-squad")
    assert_includes output, "claude-squad must be run from within a git repository"
  end
end