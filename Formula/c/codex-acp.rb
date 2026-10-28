class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.3.0.tgz"
  sha256 "01292cc857f03191a72db93055066623aafc6c11e7c5db52f6c4fa7bc8013e86"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f3ed77fc59afc4f0a1b7fec5dce9e5b2ac1b62745ce92e104484255633a34b9a"
    sha256 cellar: :any, arm64_tahoe:       "f3ed77fc59afc4f0a1b7fec5dce9e5b2ac1b62745ce92e104484255633a34b9a"
    sha256 cellar: :any, arm64_sequoia:     "f3ed77fc59afc4f0a1b7fec5dce9e5b2ac1b62745ce92e104484255633a34b9a"
    sha256 cellar: :any, arm64_linux:       "378b5c6730c8d58670f7d072fbfe7ea021b7e21dfac8c77ef663a6df54e8ef7d"
    sha256 cellar: :any, x86_64_linux:      "5183a8b9d9b0a5f9e0cf6c5f0b4a18f36f4698c31567d879a7109f76068de391"
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