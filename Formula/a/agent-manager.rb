class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://ghfast.top/https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "783f2e256b91ed70ce5c75886c20b7fc904fd9fa2b392e429a7fb55aad6a3a5d"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b8b54da91eabf3fe309908e88ad5231b9d30588f8ccb4eb681a55d4c83f78e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6bc2edaa665eb02e374e9b595e5e46ad16d71fb46c2eb1cbaff19e0bfbfc8fcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eec6e307f487f53304310445dcd79178dc6a92912e6021bc5b28fcbe3658dda6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c2a7c60384cd074b2e3d15f9225b0dd0e441cb0301a759afdddc96fb6a004d7"
    sha256 cellar: :any,                 x86_64_linux:      "00e59d68b995a6277bb4f02525f7bb5e2f7411572a02d9bd2e5fb1e03fc7e6af"
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