class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://ghfast.top/https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "7e05818c22d2e744f6dabea91e54c0bd4ddb25e0fec6a1fda82cb97374747f3e"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd18bc0dea112cab79e039aca563688afc67bf80aeae0ac785d045538140352a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b7094fa89c54db7cf8188c83ec5bdfbb81c40b8697d5f0764507e2c8283f44b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a919025906125c7f13a905ba1b115b60d5f5d4f5e0eef311ed139a7de0fa9f48"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c4a0e729cef9009d0810215956a87b14a93447abad7c65e35d4c3adcf85ac0e7"
    sha256 cellar: :any,                 x86_64_linux:      "bfae51fff635136407d59787a31e52926a6b42361286a281dce93624e943bfba"
  end

  depends_on "go" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.buildSource=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-manager --version")

    IO.popen("#{bin}/agent-manager mcp", "r+") do |mcp|
      mcp.puts '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}'
      assert_match "\"name\":\"agent-manager\",\"version\":\"#{version}\"", mcp.gets
      mcp.puts '{"jsonrpc":"2.0","method":"notifications/initialized"}'
      mcp.puts '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
      assert_match "\"name\":\"create_terminal\"", mcp.gets
    end

    require "expect"
    require "io/console"
    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"agent-manager") do |r, _w, pid|
      r.winsize = [40, 120]
      refute_nil r.expect("Welcome to agent-manager", 30), "the TUI never rendered its welcome message"
      Process.kill("TERM", pid)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end