class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.20.0.tgz"
  sha256 "e8de9d66a6cc5064543fef6def97991bf79c42959ee0c4fff0d87fb9eb793658"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e1c99cf990f2c9600c5ef6127a12d873271353648cd21c1e86b5d3448790c49"
    sha256 cellar: :any,                 arm64_sequoia: "2b05897d229f0adb1af88146a018e8f7d8fb4d75ffae03ee447c160328948e34"
    sha256 cellar: :any,                 arm64_sonoma:  "2b05897d229f0adb1af88146a018e8f7d8fb4d75ffae03ee447c160328948e34"
    sha256 cellar: :any,                 sonoma:        "a2a25776e53de79b6714759b8aa6c647f3ea71dcf79566e413e52ee3d3c61ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7f75beaf6563993846602e3d25822ba63ef18d99477a2fe31db06d155bc1a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d736fb1476321fc8fa5f906a5d64c04a001c953ee3027d5401b559389c0b3b4a"
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