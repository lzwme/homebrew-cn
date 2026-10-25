class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://ghfast.top/https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.43.2.tar.gz"
  sha256 "b20811b777e83b341bf3827ac0aa0f321c949ee3ec6ac70edf380effb5191d90"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a34b13a8ca4364e04cbcc570bd4b24f57ca881ae281dd31e1ea49942feed0c05"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df297dda6d18d5d8bf12a6bf887f5794a89222af7cd99c35f12b8bc20b987a9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7fe5196b2ad9fa0e9aea71eb0d8915b5d4bdc708df275ed3d16b96015245b65"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c91b9da59a5ff4fdbd1a52a6e347db226c84326deae59fd03cabb0d898855c4b"
    sha256 cellar: :any,                 x86_64_linux:      "9ade714f2c233675d1a42d1dd4d0ca7acc3cca780234aed9b79419c89e6944ac"
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