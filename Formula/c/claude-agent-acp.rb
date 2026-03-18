class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.22.1.tgz"
  sha256 "aec68dd60ecb65fdbc3be67941a6a1eb5eb8007f7005fc72c81b0ea7187ef6e6"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cda86bdd06e36f7fd53298dd4ff1775549695138c18a90533605cdcc5e7d7b0"
    sha256 cellar: :any,                 arm64_sequoia: "1e48777c2fe9de7b298701f689b38b6729195155c6845e4f172e7bef5a87fea9"
    sha256 cellar: :any,                 arm64_sonoma:  "1e48777c2fe9de7b298701f689b38b6729195155c6845e4f172e7bef5a87fea9"
    sha256 cellar: :any,                 sonoma:        "c3ebff735335e670150c123c22d165e8ff825529b34f13d62cb8e32561c750e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcba9b621d83a6f723ab623ec16c19f95f8715776aadc44c4a5953de46947cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a09b68f76d4f0d4cea3f8fa13232f66082a605a72125a0ac70165af543af4994"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    vendor_dir = libexec/"lib/node_modules/@zed-industries/claude-agent-acp" /
                 "node_modules/@anthropic-ai/claude-agent-sdk/vendor"

    %w[ripgrep audio-capture tree-sitter-bash].each do |dep|
      dep_dir = vendor_dir/dep
      rm_r dep_dir
    end

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    ripgrep_platform = "#{arch}-#{OS.kernel_name.downcase}"
    ripgrep_vendor_dir = vendor_dir/"ripgrep"
    platform_dir = ripgrep_vendor_dir/ripgrep_platform
    platform_dir.mkpath
    ln_s Formula["ripgrep"].opt_bin/"rg", platform_dir/"rg"
    bin.install_symlink libexec/"bin/claude-agent-acp"
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