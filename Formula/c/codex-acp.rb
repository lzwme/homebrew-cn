class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.4.0.tgz"
  sha256 "027a35ca3bc45533260b5599c4fec593db0e26654add46ba8e1e0a1dd65de573"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33b4e1d5b0ab72ac760ab6418c7db57fa4c60fbaa4f1a6740a8922d6d81250ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33b4e1d5b0ab72ac760ab6418c7db57fa4c60fbaa4f1a6740a8922d6d81250ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33b4e1d5b0ab72ac760ab6418c7db57fa4c60fbaa4f1a6740a8922d6d81250ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ab092d65a8627fbd0f4546a1739dd5d9f7eaf304d715a53dcebaf75d4103ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f8c9fc8a49c930cb8e78bf14760d06c7ae11d6eb1721c11ff6898a985030283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b8a704e493d122ffbffb70000067d230f4fd771c10d0e28b7512d14cfc27787"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    rm libexec.glob("lib/node_modules/**/codex-resources/zsh/bin/zsh") if OS.linux?
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _e, w|
      stdin.write json
      sleep 3
      output = stdout.readline
      assert_match("\"protocolVersion\":1", output)
      assert_match("\"agentInfo\":{\"name\":\"@agentclientprotocol/codex-acp\"", output)
      Process.kill("KILL", w.pid)
    end
  end
end