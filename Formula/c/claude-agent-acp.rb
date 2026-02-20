class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.18.0.tgz"
  sha256 "8618836b675d11a67f1b4f024c0f9c1ae881f9aa14dacb330d848ba596d2ac52"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74a33be94e694aa12c47a289b762e14c51cb087fdaa69061f1799f3d09057be8"
    sha256 cellar: :any,                 arm64_sequoia: "97a2edfddde00f957ed0680528f0ab9c4e0dbaf2dbc861fae2359e0b648994f3"
    sha256 cellar: :any,                 arm64_sonoma:  "97a2edfddde00f957ed0680528f0ab9c4e0dbaf2dbc861fae2359e0b648994f3"
    sha256 cellar: :any,                 sonoma:        "fca800a82b3f625518471825561ee89f20282c241d61c3da0134a27b57131535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67e4e8a44e55d5e4f9e26c69bc771a000adaa8b5c09be4813e55369680c695e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6b83503585083c5af8c10e3ddcaca856f9e6918e9cc086145391d351fbdf4f0"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    ripgrep_path = libexec/"lib/node_modules/@zed-industries/claude-agent-acp" /
                   "node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r ripgrep_path
    (bin/"claude-agent-acp").write_env_script libexec/"bin/claude-agent-acp",
                                              USE_BUILTIN_RIPGREP: "1"
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"claude-agent-acp") do |stdin, stdout, stderr, wait_thr|
      stdin.puts json
      stdin.flush

      output = +""
      Timeout.timeout(30) do
        until output.include?("\"protocolVersion\":1")
          ready = IO.select([stdout, stderr])
          ready[0].each do |io|
            chunk = io.readpartial(1024)
            output << chunk if io == stdout
          end
        end
      end
      assert_match "\"protocolVersion\":1", output
    ensure
      stdin.close unless stdin.closed?
      if wait_thr&.alive?
        begin
          Process.kill("TERM", wait_thr.pid)
        rescue Errno::ESRCH
          # Process already exited between alive? check and kill.
        end
      end
    end
  end
end