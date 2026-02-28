class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.19.2.tgz"
  sha256 "0f12911e763ffb63e40d904c4a66cba47a5b1a5d73a0f7b80a7a9ab0246cff95"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "766bcaa98c189d22a9e46066468d5d47d0d5a87bd213072861d8fa520d427c63"
    sha256 cellar: :any,                 arm64_sequoia: "79e10069adae41b68e68e276081312a00492accb770b92600773116acf687d4a"
    sha256 cellar: :any,                 arm64_sonoma:  "79e10069adae41b68e68e276081312a00492accb770b92600773116acf687d4a"
    sha256 cellar: :any,                 sonoma:        "93ca7c61a4c710d9757b7750d3325559b1ab5eb038a9f2c4cd8582516728720b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f51e69ccec32ef9f6c59d0b52338ecdd70a264689dafb22cd21a7f85a9947085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4532a815c1e196619cf75ff6e42cb012503a2e3cb8f3f5f2cfa4312c55615dfb"
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