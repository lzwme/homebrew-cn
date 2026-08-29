class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.7.0.tgz"
  sha256 "b829d13edd72ec441ac5528100c3008d3782844f972bc9ce180e1968a4974020"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77a612e0b4526aa283a562eda6c7a1ce896e9899b743651900122bb6eca78dca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77a612e0b4526aa283a562eda6c7a1ce896e9899b743651900122bb6eca78dca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77a612e0b4526aa283a562eda6c7a1ce896e9899b743651900122bb6eca78dca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf98a9dbb557c80db51dc5fdf0cb0e4cddecf5504d54854ab219eb3d4885c29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17534c71f1e33707de25bce9a275af8124920019af6610519f331aa55cf1d4a2"
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