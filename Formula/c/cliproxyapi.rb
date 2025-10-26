class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.31.tar.gz"
  sha256 "4ced8ea3225cf0dea9ea54fecf8bf7fdca0b552e6b26c042cb1c1ae9cd95033f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "63019e4db2f5fae5d1fe2d0fa63893639cf1a3753c8ca34fadce7a7a55c31636"
    sha256                               arm64_sequoia: "63019e4db2f5fae5d1fe2d0fa63893639cf1a3753c8ca34fadce7a7a55c31636"
    sha256                               arm64_sonoma:  "63019e4db2f5fae5d1fe2d0fa63893639cf1a3753c8ca34fadce7a7a55c31636"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b94e0bd505c2688e6b496a0b41758418f926c6f6d1a042e3a4b3d22844693e9"
    sha256                               arm64_linux:   "6378758b9e76a25781f604543734f451462b4faee6eb3da1127fe2f42652b25b"
    sha256                               x86_64_linux:  "841f44fde3e30e61bce6d36af82826c5f3279f6444ca131ffaef96f8a3b13b64"
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