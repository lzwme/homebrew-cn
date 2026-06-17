class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.10.tar.gz"
  sha256 "40f1003721edf7d75acee017b759aa098252efda23bfe557534053c5d317d94e"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "9ca7dd81a15f749e8a496efe2e33368920546b9c63450abb0dd4cfa9a2ad13bb"
    sha256 arm64_sequoia: "cb9acd2601079714adc0ad83c9578b5a7cce669261f7c4081160d8b28bb37916"
    sha256 arm64_sonoma:  "1fa841bde47d28c43c4f5141be7699e2d8e47ae37dea8a7a039709eacac59ebb"
    sha256 sonoma:        "9677d4f6feeecda93f551dcf9961683902b1463db5bc9266693a52b35f995d04"
    sha256 arm64_linux:   "686eba3d6fadb15a6c24627741563f9c7069b4d1a810747204939f2526d9f623"
    sha256 x86_64_linux:  "77cd140cdcaccf45ac5704094503f78145bc9ff35e2792518d75c16520ca01c9"
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