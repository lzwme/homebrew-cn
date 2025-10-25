class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.30.tar.gz"
  sha256 "6148ea374ce7bece7c1d777826de3c6019619f934bfe7301d55e27a9957d54ac"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "85fa71bcc32f10eca3cb99c32a9a4c08583e4bc6b5282d6946bdcf9e33c67dea"
    sha256                               arm64_sequoia: "85fa71bcc32f10eca3cb99c32a9a4c08583e4bc6b5282d6946bdcf9e33c67dea"
    sha256                               arm64_sonoma:  "85fa71bcc32f10eca3cb99c32a9a4c08583e4bc6b5282d6946bdcf9e33c67dea"
    sha256 cellar: :any_skip_relocation, sonoma:        "bea0d3a0266897f2b1ea03e30e2906a23be27accbbf1fae4057f1ddb11b44f51"
    sha256                               arm64_linux:   "6ca49c7f552511089fd0a9da73eef278bbaa413d2e129d8774727101d2428451"
    sha256                               x86_64_linux:  "5c549631bf93bcdf7513d110426f9969dcec13f305e84b61df39ccd0640a9d5d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
    PTY.spawn(bin/"cliproxyapi", "-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end