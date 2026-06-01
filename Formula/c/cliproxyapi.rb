class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.35.tar.gz"
  sha256 "6fad332c3452c2c599320d2dfe5864e268de4d32ebe3699a31763860fe390cb1"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "3950760fa08ce7e233fb4d823f6368a0afccbb9edabae45ca53fdd3ed102a6f4"
    sha256 arm64_sequoia: "3950760fa08ce7e233fb4d823f6368a0afccbb9edabae45ca53fdd3ed102a6f4"
    sha256 arm64_sonoma:  "3950760fa08ce7e233fb4d823f6368a0afccbb9edabae45ca53fdd3ed102a6f4"
    sha256 sonoma:        "c022316b5b5b41bda902e05b6bc38f69501232b1cfd8b2172d5a3b0b370f77de"
    sha256 arm64_linux:   "689b1d55f2a347ed28765dcc3611f05bc2405716531cd839a9549cbedc1a1b5a"
    sha256 x86_64_linux:  "3692c6dfa19dc54c3cd53ed8b19c885b66676c7ec1289ddca5bb2d299dc3f0e3"
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