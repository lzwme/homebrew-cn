class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://ghfast.top/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "505de9a909d9b04b9c0ee7576eab83cb8ca878815c662196aa585547caacc0fa"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56890bb655e597637c39175c09375d92d74c126fbadbb9156ff1941bf2cf2d57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8e197d0ef3e9388eeef44bb61f0aec04c70cfa043b969d1659762b75f5861b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cc3c8b8ddfdc52fe761b60ae1d0367663e0a66b880a7d1b24ebbdf969b2588e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc8374b3477dad146d9823e9d868296cb085e7dd0d75a46e62b8aea96b94615f"
    sha256 cellar: :any,                 arm64_linux:   "d3a603304038c8b18e739974de96962c7abe0852d4f346893979c905cef8f6f0"
    sha256 cellar: :any,                 x86_64_linux:  "82709a4ad38fbc57644c8acb5c63c09c9176fb277eb4665606ce99f1a0f76e69"
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