class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.10.0.tgz"
  sha256 "9dffb525b728d0579a8b19d48322281ecad7eea7ba1640fa2f8de1199346352c"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3de1a43477c07a125fe13e997beba8f6922044ef8c217e7be176072aeb04b06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3de1a43477c07a125fe13e997beba8f6922044ef8c217e7be176072aeb04b06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3de1a43477c07a125fe13e997beba8f6922044ef8c217e7be176072aeb04b06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6de8f59214f0d47ebb389b6c520934454423bfd114a22276508d0278f8faa5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b79c3ab28dfd6c999996208ff6b8a007c936e33ec429c3468ea5972f63a9a72d"
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