class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.1.1.tgz"
  sha256 "9da0d580518d006d257609a4b64b7c5bd96a7f36f2d86db5c8f2cb9385de5872"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "342107525dfd005d189cdd0a9c85fc9133851a0cde5114d66ddffb8b53660f1b"
    sha256 cellar: :any, arm64_tahoe:       "342107525dfd005d189cdd0a9c85fc9133851a0cde5114d66ddffb8b53660f1b"
    sha256 cellar: :any, arm64_sequoia:     "342107525dfd005d189cdd0a9c85fc9133851a0cde5114d66ddffb8b53660f1b"
    sha256 cellar: :any, arm64_linux:       "8ebebebc31dd13a04389ef7d7f702d2cf3571fdbbfa8c7cba8b147eb684aab7b"
    sha256 cellar: :any, x86_64_linux:      "9bda16a2ef26bc2267e7a1dc471ef76b7216ac2aaba2e76eee3b2436661550b3"
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