class AgentManager < Formula
  desc "Terminal UI to manage AI coding-agent tmux sessions"
  homepage "https://github.com/YoanWai/agent-manager"
  url "https://ghfast.top/https://github.com/YoanWai/agent-manager/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "be00eb6b9fe7dfcf3c5ccfce0bd0823c7cb460fbcaf725cd148c54e8d213df80"
  license "Apache-2.0"
  head "https://github.com/YoanWai/agent-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47cf6701b93cc927ba9e1ef418c8294af656bcc7402d6017aaff3be36d64e841"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "358424adb2d6c0703767e36f3830aeeaa3b6a12435ec46447238fb6cc5f565b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95b00714351d39e3a09626669d021b9a91f9e70e1f402040bb8bdc8f6ff25916"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16e5a5e70d141132339aef77421ca3a0fa19b25f658b0df0c9491fbb9108da5d"
    sha256 cellar: :any,                 x86_64_linux:      "5cd9f1b38b32bf2895f0fd8b2e508f64b317a8a9c920cbe85e48c8a6e62296a0"
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