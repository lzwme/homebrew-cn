class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.40.tar.gz"
  sha256 "ae9db9a21491343a04120a344c4e815d02a25d090c2ca47437cd3f4c2d61ba7a"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "00111d52f1a3097b59c3ddb84d3e0ad788f4d5f18f6076fb94038d4351525068"
    sha256 arm64_sequoia: "00111d52f1a3097b59c3ddb84d3e0ad788f4d5f18f6076fb94038d4351525068"
    sha256 arm64_sonoma:  "00111d52f1a3097b59c3ddb84d3e0ad788f4d5f18f6076fb94038d4351525068"
    sha256 sonoma:        "83d05f1c61b3d5e9515c5b5722e231384a517fe71add781a4446b1fae08a715d"
    sha256 arm64_linux:   "737b4d5e7d5412eaa3a08bbef2690b21c1411059b0db9a5468538bf14d3053cb"
    sha256 x86_64_linux:  "bbf49e24d757203520ec997e38f62083b9951829174813f93d40f7549054b5f9"
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