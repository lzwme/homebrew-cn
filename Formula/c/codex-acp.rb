class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.2.1.tgz"
  sha256 "5bf1cfcb11fbf3004295ab542f0fbcafc15fe38980fb95fecd5c5a6e0ab162f7"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "34968340a5c19f7f08a35ffa6120cff3fdb3ec26dea2e20ec0ee57e3680db08c"
    sha256 cellar: :any, arm64_tahoe:       "34968340a5c19f7f08a35ffa6120cff3fdb3ec26dea2e20ec0ee57e3680db08c"
    sha256 cellar: :any, arm64_sequoia:     "34968340a5c19f7f08a35ffa6120cff3fdb3ec26dea2e20ec0ee57e3680db08c"
    sha256 cellar: :any, arm64_linux:       "9923743da0b79a2936c57bb6541c3731c39fdf9e757f7f62485ba8c1605e5cd0"
    sha256 cellar: :any, x86_64_linux:      "2e0d04d24e24b5457c972734c5375598051561bf436613a6f444ee6964f4c5a5"
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