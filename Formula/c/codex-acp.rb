class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.1.0.tgz"
  sha256 "3e6f7c54a0d38f51f7699d1a889c3f346f2c49fe23a7cfd3941507d67c6e4cdb"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "570710f8262a99744cdb620a05ea9ab91cf07482e4ac13188ca2edb56852bba4"
    sha256 cellar: :any, arm64_tahoe:       "570710f8262a99744cdb620a05ea9ab91cf07482e4ac13188ca2edb56852bba4"
    sha256 cellar: :any, arm64_sequoia:     "570710f8262a99744cdb620a05ea9ab91cf07482e4ac13188ca2edb56852bba4"
    sha256 cellar: :any, arm64_linux:       "fbec1b25fb5c8d4b65054759ac8db062ee6e2e4e03d46171779490e19172df5f"
    sha256 cellar: :any, x86_64_linux:      "c314cabca59bc3737b02b46cb9d07e6d24201270fff50de27eb11276fdc843e8"
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