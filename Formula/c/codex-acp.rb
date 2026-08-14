class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.2.0.tgz"
  sha256 "56b0c98459aeb16d09dccd9848e1ebd8f32a8dfbc969ee86d4ff07f47bf507ba"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "838a48731a6b9865fa4cc7c175605dff099cd83d4ac6ae037286385a7ec3ac52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "838a48731a6b9865fa4cc7c175605dff099cd83d4ac6ae037286385a7ec3ac52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "838a48731a6b9865fa4cc7c175605dff099cd83d4ac6ae037286385a7ec3ac52"
    sha256 cellar: :any_skip_relocation, sonoma:        "f616b39d64377a65bea23337f7f6f79b8f511fac079ad1d6759c01a8352b9b5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad63d6f58b26d0d56f21b65deab38fe0ee98145d711dbd497e6fcbe512403f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71aa43e9d40b09e91ee92997e9dc46fd446da701178b80c6c144ffe994f6cfe"
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