class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.0.0.tgz"
  sha256 "a8d48bdf70c0e3e585abbdce19f78765450d8fa6ada1da0fd53508e64315905b"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eca06cd4ef3585d257b72027dccdd3bab038c85f4e0cfa15b7edb35a2759d677"
    sha256 cellar: :any, arm64_tahoe:       "eca06cd4ef3585d257b72027dccdd3bab038c85f4e0cfa15b7edb35a2759d677"
    sha256 cellar: :any, arm64_sequoia:     "eca06cd4ef3585d257b72027dccdd3bab038c85f4e0cfa15b7edb35a2759d677"
    sha256 cellar: :any, arm64_linux:       "a7650c9db6bebcf72f6d097cb3320d899162bf7fd2cee8290bf9b2cd5e974491"
    sha256 cellar: :any, x86_64_linux:      "ca75446686e90259b3019a2a7ee27caf54e5c7ecfeb261a9e41a446ccb98bf58"
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