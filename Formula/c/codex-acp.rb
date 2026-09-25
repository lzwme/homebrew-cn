class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.13.1.tgz"
  sha256 "93e2f215d9d68eb43afc98f46038eecf973996c0c522a8915249148b6ea35e01"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "81013980d3deb408bf4f069534c84f1b7800263a728bb202c8a8a82314ccceb8"
    sha256 cellar: :any, arm64_tahoe:       "81013980d3deb408bf4f069534c84f1b7800263a728bb202c8a8a82314ccceb8"
    sha256 cellar: :any, arm64_sequoia:     "81013980d3deb408bf4f069534c84f1b7800263a728bb202c8a8a82314ccceb8"
    sha256 cellar: :any, arm64_linux:       "a7bab535b401f44589d92e5e8d914ee863788a43a2bfe4cc9ddd22d3790fbdf8"
    sha256 cellar: :any, x86_64_linux:      "4c9698c5211563d837c66d94e3b043bd4edda10e054f9a4504620d60a061b97e"
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