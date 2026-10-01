class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.0.1.tgz"
  sha256 "e59aa7c9c04bdda35f0194f2ea71cd256318b8c8f907a547787bbd0a2390b9dc"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f9e80a4744a6b42cc76a0357d5f919f8557e5d563e7747fb7cd23fe9a3d702c3"
    sha256 cellar: :any, arm64_tahoe:       "f9e80a4744a6b42cc76a0357d5f919f8557e5d563e7747fb7cd23fe9a3d702c3"
    sha256 cellar: :any, arm64_sequoia:     "f9e80a4744a6b42cc76a0357d5f919f8557e5d563e7747fb7cd23fe9a3d702c3"
    sha256 cellar: :any, arm64_linux:       "01ba1832800e815f7a3c2218f0757466503538c87000d2060d6f894d91af5c71"
    sha256 cellar: :any, x86_64_linux:      "3f5d12013b1b783f1fab59a27d121c482f963411ce447937168be0acc9567802"
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