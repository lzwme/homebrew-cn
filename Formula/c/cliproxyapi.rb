class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.9.45.tar.gz"
  sha256 "7e4b6588a8997fac13b2e1113e353b4aab96ba60c03712083bc3b9c81bf2c314"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "229f4f1932c7949bc91311f046c15ea845ceb91876eda6d34735471a683f1275"
    sha256 arm64_sequoia: "229f4f1932c7949bc91311f046c15ea845ceb91876eda6d34735471a683f1275"
    sha256 arm64_sonoma:  "229f4f1932c7949bc91311f046c15ea845ceb91876eda6d34735471a683f1275"
    sha256 sonoma:        "1b73da9f8e7a8d177d2e4f158ec050e8fb7dd0f37caad3354f7aed6154d6c0c3"
    sha256 arm64_linux:   "e9ca16349b3e1fada0b23411a182e294411a07d0813553091cd13ba08e414fc4"
    sha256 x86_64_linux:  "849fcc06eba1db7fec3c0cd2b7677a85adac21b8ffc1e9fb27de94ae9941cb77"
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