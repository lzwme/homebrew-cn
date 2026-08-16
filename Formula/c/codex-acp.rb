class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.3.0.tgz"
  sha256 "63596b17c0b01dd9d0cc71896bae4f53f1ee8e3267cdf4e0cb094326558b8807"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea31fbb10e3a5e81e0a16031e45de3e77a2e162b82761b5b7fecb5656ddf7a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ea31fbb10e3a5e81e0a16031e45de3e77a2e162b82761b5b7fecb5656ddf7a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea31fbb10e3a5e81e0a16031e45de3e77a2e162b82761b5b7fecb5656ddf7a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "feef7166623f1bbe9199eb30b3fb4014c9dc5542442b73bec8710ac99409c7de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30318503d8745d8d06c1afa198e42ec62a9072e0c6ee794b8dcad86c3b290cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af56f5f7f181a89b41060543d8ca96b100bd3befc5b4f859284924ce0e30f284"
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