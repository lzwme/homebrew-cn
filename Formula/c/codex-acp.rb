class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.6.0.tgz"
  sha256 "36f240ffca370c24eb34df96204e44d4a6d0eaf9083c48f02886af9dd86232da"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6be38b3bd2ff1c603c7377661da273004bfe734452a5a672319f009889047c7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6be38b3bd2ff1c603c7377661da273004bfe734452a5a672319f009889047c7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be38b3bd2ff1c603c7377661da273004bfe734452a5a672319f009889047c7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "450b53ee131eb435f7f023004d7aa35fb7a482b7b25568f22b4ea18129aeabdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43b4353d7b0ba2df5edc646436b9d7246ff645137f5f4507e650c09a6fba9f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1607b3f19973e07b7051301f727e969c0e3f5df34164ebbcc5ae3f98f298617a"
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