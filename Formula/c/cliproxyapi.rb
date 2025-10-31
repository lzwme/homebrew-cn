class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.1.tar.gz"
  sha256 "b4501f2989fb1f3daa33e7da5ed6402da7284de61617ebf645487a9d8ee1c889"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "db1008f55f53ed24ca642f6db67e626944262042cbc284ecb154e4a184283bf4"
    sha256                               arm64_sequoia: "db1008f55f53ed24ca642f6db67e626944262042cbc284ecb154e4a184283bf4"
    sha256                               arm64_sonoma:  "db1008f55f53ed24ca642f6db67e626944262042cbc284ecb154e4a184283bf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a770cbace7f032bbbb365c2ef0cc9366950598ecded0f14b625c2e0adb99a8e8"
    sha256                               arm64_linux:   "1246c735a8874881b20234200e4acdfdd3819ee4a27ae5894321adc11102f2bf"
    sha256                               x86_64_linux:  "88b8cdd82b07f4bc488e4f13f004bc9296615e0b0a0fc360c3e8073f2275d2ce"
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