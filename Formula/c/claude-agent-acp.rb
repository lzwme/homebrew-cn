class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.20.2.tgz"
  sha256 "73ac373dfdb50dd2a8aed033d65adac762a469cad0e3e38c866760f755149f5b"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee7bcab68f18025c9857421f7be20c6f9f6e2c3d5819e260603c1f7348303c73"
    sha256 cellar: :any,                 arm64_sequoia: "bac2aa219a7610ff81412af3bab63464dec58da44923d9d48ff759e023981036"
    sha256 cellar: :any,                 arm64_sonoma:  "bac2aa219a7610ff81412af3bab63464dec58da44923d9d48ff759e023981036"
    sha256 cellar: :any,                 sonoma:        "e59e14af30636a75a447f69397236caeab3653af09f015a416e8466a2bb878f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10184b4258e8cec400ae22f10ef91bf32aac8f9194e3f537ce0a3458ae686bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57caff9c55eae04fe4def313e7fb0005e5a7ad6c67f62c522049536535f570d4"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    ripgrep_vendor_dir = libexec/"lib/node_modules/@zed-industries/claude-agent-acp" /
                         "node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r ripgrep_vendor_dir
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    ripgrep_platform = "#{arch}-#{OS.kernel_name.downcase}"
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