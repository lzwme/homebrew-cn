class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.11.0.tgz"
  sha256 "b2fa065a4dfd3eb4262b87c1211b3cddaa0f0f1c49e284ad6d8182501fe4d51b"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "650d8b5e315e4011028e5d6bae2346667c2bb660004b97648287717de2724460"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "650d8b5e315e4011028e5d6bae2346667c2bb660004b97648287717de2724460"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "650d8b5e315e4011028e5d6bae2346667c2bb660004b97648287717de2724460"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "11dbaca3e2a529109e2dabddf6499dc86ec314609c9d414ba3fb07bc734e4189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "adb9db0c93f95a98cbffb1bb4e826f5f150bc699a35c6083e4b6674e71df2c70"
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