class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://ghfast.top/https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "d085a8a1715dda210f611f5abd8a4f60dc0950277d4a92068da780891fdf05fe"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1cc75e3848c860d93283906d7925d7b85a1a2a8d0f336a97d36147dfe9647842"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c3d086d67729c2f9c595d09aa592c69f33b7e651d5e0ed6e4876d9244f2dce7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d751d82ec084e62901b7ef739e1ed9b8a22b7bc6afc17e49744cfafa54e61a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "58af442c05191a841ee80b82f50d083d07b902ffaf83c45f171ee4832da0e623"
    sha256 cellar: :any,                 x86_64_linux:      "a0ef0e0468eefc3dbe4ba92283d3447cae866cb56e57f840b9c70511ba744418"
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