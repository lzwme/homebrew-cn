class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://ghfast.top/https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "496b0e1e98876758bf69d9eeb6d86aff059da0820377b00b961e68601678eef6"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bbe7a5e94636c4117d6ae777324cdfdf27cb35c136d986403409e8afb3bae27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d672a110ec796269834e7ebd0749493bb698b4a37831378e75751be149b4b786"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6181a66fefe8ec3c643bff936a93d7839f8c83d14e5432680e9a239a036d2353"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7383c9d12b7ede23599e17f5ba46a532cc415aad26ed38a512094ac6f2308ec9"
    sha256 cellar: :any,                 x86_64_linux:      "0ae9e9285130333c2e926124cd96f88b8ef3b609feb4d2af235a9102a5fee00a"
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