class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://ghfast.top/https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "19951f70917aef7fda3810b47e3e2dc3110fb04027ff5dbbe3f3c502999b9610"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d25d4a32533b88fe9647e2b5f3490a56f44c3b3e6e6e0f016d7bd9a2889da01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d25d4a32533b88fe9647e2b5f3490a56f44c3b3e6e6e0f016d7bd9a2889da01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d25d4a32533b88fe9647e2b5f3490a56f44c3b3e6e6e0f016d7bd9a2889da01"
    sha256 cellar: :any_skip_relocation, sonoma:        "318a9572dfd22273eddc53aaea2f0000b20b26b4147617a15bad02814776e16d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd30d9753dea2b1415087f1dd474d8415a70c85adc52cd7ddca500a2c2489121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a9952a066bab2bba7caf2310d2ade8dd4cb133583d75a75ed245994a2aecf3b"
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