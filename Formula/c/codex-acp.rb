class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.13.0.tgz"
  sha256 "c9787b0699085e3db3a744efcc59339cf782e495dcb7836d03771e0590b9508a"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "357943acbb97cafb2670253b0fb759cf6bd05d5f317b15b388a93eb8645285e9"
    sha256 cellar: :any, arm64_tahoe:       "357943acbb97cafb2670253b0fb759cf6bd05d5f317b15b388a93eb8645285e9"
    sha256 cellar: :any, arm64_sequoia:     "357943acbb97cafb2670253b0fb759cf6bd05d5f317b15b388a93eb8645285e9"
    sha256 cellar: :any, arm64_linux:       "832f979112bac57565708d7dd858a4a52877cc3b8236c69e59f2455b81682f0d"
    sha256 cellar: :any, x86_64_linux:      "e07e9fcf767a214e9dd7efc26f3b97c3d9b688b404725c33816825972f2e9f03"
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