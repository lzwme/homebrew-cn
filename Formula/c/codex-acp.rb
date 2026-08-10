class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.1.14.tgz"
  sha256 "674e4e939ee373e42bf7b1eece51c42cb7a8dd5b564523eea1b1fa8bbdfbce03"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a81df678da52eaa988a9403e49e621b0c0376bd1400c43bf15ceb165386e638"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a81df678da52eaa988a9403e49e621b0c0376bd1400c43bf15ceb165386e638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a81df678da52eaa988a9403e49e621b0c0376bd1400c43bf15ceb165386e638"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0ac817f02d7d75d96c554de27d68816f05a40e01bd96a731823f5ef149b352e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f644481be8a990d0576eb35edc734b472b505c5c3acaeb29f161692a0020df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbdf7226852f6a145122131555f2ffa2632bdcb842502fd92c1a0f7f4b321e79"
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