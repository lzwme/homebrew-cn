class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.20.tar.gz"
  sha256 "6d0adbc2935bb7609b1584c59a2870421d9bcc817eae84b766894c48ea8e2b8a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "27092050fa4cc366f0827ad9a66ec4e678e6bb7131146b4a338f49ae76874f6a"
    sha256                               arm64_sequoia: "27092050fa4cc366f0827ad9a66ec4e678e6bb7131146b4a338f49ae76874f6a"
    sha256                               arm64_sonoma:  "27092050fa4cc366f0827ad9a66ec4e678e6bb7131146b4a338f49ae76874f6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf029d5930c4b14c74598ce8ca52b345e072b8a08cc1792f103b0edd8681abac"
    sha256                               arm64_linux:   "5d1aa16425d64f33f65599b462535b330680793dd56c182e6dbadbc96f6dfa63"
    sha256                               x86_64_linux:  "035445393e046e07969aef9b7f85a10fe67ce3c639ba27948ef265d7e999d40a"
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