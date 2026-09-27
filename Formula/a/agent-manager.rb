class AgentManager < Formula
  desc "Terminal UI to manage AI coding-agent tmux sessions"
  homepage "https://github.com/YoanWai/agent-manager"
  url "https://ghfast.top/https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "9589e5c867a2c0d78515778f28ffb0432362093fbc618ce6d701fa5f403735eb"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11ebb43b4ed698044eebc9d291155e4cbde2e0332b0809b472ca381fd8274a8d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5171229c0bcd704dcf70ee404ee9fda036bf4c456751f62d72fb562114828db5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30edd223559e1af71457a121d4031babb3714711bdbd8128cdb15166a189dd73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "06adab31d3dfd35cff6daebbb15ded2069f1fbc1581ecfa3e087dedcb66a07ae"
    sha256 cellar: :any,                 x86_64_linux:      "2d06d22f99506c2cb30aa6ad562fb9ee59f667e7855b927496bad829c9361e24"
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