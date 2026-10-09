class AgentManager < Formula
  desc "Run Claude Code, Codex, OpenCode and other AI coding agents in tmux"
  homepage "https://agent-manager.dev/"
  url "https://ghfast.top/https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "aee204b310eb00965133bffcfdd5cdeae97db0be8d1767999459105cf2bfec12"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b154d14b8ccd2ec4f160596887876a4ff897780572a7e1219d72908eb8f28b09"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ccfe30e4f1f82d209d8c90694dfc89715edc6530adbf9bf68e878fcc22e4b0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b33ee7390fe88c8a0a31bf90be3c9a3bd980667c67483588e9cef61e6a24fab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afc863a20b1bb386f32d31ff91cca686ad82fefd26fab2efc5b9e5b4369d098f"
    sha256 cellar: :any,                 x86_64_linux:      "fd3b75bdc53989f39f24224e30e0945c2d8554fa863972eb6741398b7d529db0"
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