class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.15.tar.gz"
  sha256 "08ed9e6cb3b1c63f7a9b2b0f314350101b3b7673211d24c949e8a5820fb4e6ba"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "e380dff95cedf0814039d9172755b8cf7374bd79f0548ba13d6c934671d86242"
    sha256 arm64_sequoia: "e380dff95cedf0814039d9172755b8cf7374bd79f0548ba13d6c934671d86242"
    sha256 arm64_sonoma:  "e380dff95cedf0814039d9172755b8cf7374bd79f0548ba13d6c934671d86242"
    sha256 sonoma:        "60547df5f8dd1da498405ba576ee78c61f88796801373d10bd287dededc4aef1"
    sha256 arm64_linux:   "1120d1e9fd0e52355ac78d750c61438879bf6a4905d1b8312e2a15cea877f76b"
    sha256 x86_64_linux:  "ba6b1a3538f6d94ccada98015be9c353965b65fb1a89992eb5110d39fe680e18"
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