class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://ghfast.top/https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "dff682cca9565ba5aff21c4a9a6a295097a633def9d5b89872987c52ce4c1404"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce0f9217a36b72806bf8c839579bfadff9d14834fac7205c7e05721fa9ec372d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce0f9217a36b72806bf8c839579bfadff9d14834fac7205c7e05721fa9ec372d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce0f9217a36b72806bf8c839579bfadff9d14834fac7205c7e05721fa9ec372d"
    sha256 cellar: :any_skip_relocation, sonoma:        "95ba502d40df7d7c42b60fdfb5a7f96099c78afaf47cb1895eb24820f8a7bc4c"
    sha256 cellar: :any_skip_relocation, ventura:       "95ba502d40df7d7c42b60fdfb5a7f96099c78afaf47cb1895eb24820f8a7bc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c7c3c6554ee70524c9650576e913ded0217ec5b0be54f2d31665a6f88210790"
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