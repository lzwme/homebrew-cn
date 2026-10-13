class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.25.tar.gz"
  sha256 "9e0000a9ff123a820c3893ca48e7a21326b46f510cae903f5d8082e6031ad66d"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "173b780e5d8a2d2ca7383c0766dac1a53aa88f6578e4bf6ebbfe5ed2d5e44920"
    sha256 arm64_tahoe:       "101579b03800eae834ff054a57e72fa667eb7625bd73f10e4294b5df76570144"
    sha256 arm64_sequoia:     "39d1a9db3eea420aa63bed1bce0ea7521aed43735109d8791fb89ce472c1517f"
    sha256 arm64_linux:       "2d11e4013005905e314034525778a6fb7003c7b58ad479afc25933b603247e37"
    sha256 x86_64_linux:      "ea27e761b5dfdbf2e66ff5f14ff51ddabeeaf80013cc72b31b03d89b00f79028"
  end

  depends_on "go" => :build

  # `test do` block needs local sockets for the login flow
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi.conf"}
    ]

    system "go", "build", *std_go_args(ldflags:), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    require "pty"
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end