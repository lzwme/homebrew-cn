class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.26.tar.gz"
  sha256 "58aab3f224a38629ed3755537b7205c1c6cea5eebcbeaa4821a85d143f1c6d25"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "159b346f993fd8be51ca5c6a7aeb77feff78c7bfebb9b901b2cf7ccb348c6f28"
    sha256                               arm64_sequoia: "159b346f993fd8be51ca5c6a7aeb77feff78c7bfebb9b901b2cf7ccb348c6f28"
    sha256                               arm64_sonoma:  "159b346f993fd8be51ca5c6a7aeb77feff78c7bfebb9b901b2cf7ccb348c6f28"
    sha256 cellar: :any_skip_relocation, sonoma:        "bce34d0f040592f22ad09d044d901ad5696b0559e68f78b88629aa68fbcbd2fa"
    sha256                               arm64_linux:   "0f4bac947c6e36b21fa8a5b927ce021db6f1077d5830379f0ca8fabfd9ab658c"
    sha256                               x86_64_linux:  "a906283e93712078b10b1bb9c47e881df94abd278e463c892cbee20c6e93754e"
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