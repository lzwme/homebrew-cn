class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.53.tar.gz"
  sha256 "89084c1d4490cea7d7505b8ad75fa6aabd6043e401ffc237f506bbd66773a6e9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c87719a436c0f287fedc30e0303c594cfb36edb0462a75f6b04df13c9c50a791"
    sha256                               arm64_sequoia: "c87719a436c0f287fedc30e0303c594cfb36edb0462a75f6b04df13c9c50a791"
    sha256                               arm64_sonoma:  "c87719a436c0f287fedc30e0303c594cfb36edb0462a75f6b04df13c9c50a791"
    sha256 cellar: :any_skip_relocation, sonoma:        "45f72a8f2cfe71a377dfbbf0198fed0b3a48d2beb13363d1e91c66d0fc03dde6"
    sha256                               arm64_linux:   "68ed01800695476a424b4d0b3c097d188bf35b2331a61c76cd55247e4a5b3b59"
    sha256                               x86_64_linux:  "b19ebd65c74b140848772df857e7316ab82a614b11d7e5decf1faa8d43c9853b"
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