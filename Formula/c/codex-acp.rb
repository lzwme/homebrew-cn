class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.8.0.tgz"
  sha256 "5469c82d3545b1112622544e16b4d6931c22adf322fbf20e7664ee8fc8937ab2"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e730c51ff4b7b6bb55447ddb3010e580f5d2636578cd3e26b668295498e3db8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e730c51ff4b7b6bb55447ddb3010e580f5d2636578cd3e26b668295498e3db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e730c51ff4b7b6bb55447ddb3010e580f5d2636578cd3e26b668295498e3db8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34458b9258e398eae910f6f22480602c0433bc61a6f81707439db2dc3a2d7625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7632318385b7585043730ad532a6b2c138449933b5f3f1ce164bf80526a74a2f"
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