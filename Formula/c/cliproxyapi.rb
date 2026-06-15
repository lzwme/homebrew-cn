class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.0.tar.gz"
  sha256 "9434605c1d191398882c0d9b2a091490ed8bf3cefa8c5439e1b4f04578d6ff96"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "f207f2e65dec7a0465cb9af4d5c1728bc591e19121bf21c0dac25819d004dccc"
    sha256 arm64_sequoia: "3a307579c5dec21e61d1a04ffe38db94e7cb2a4464837713c6c5f2b58e7145a2"
    sha256 arm64_sonoma:  "838fe99105a5d1761e2649d500874c65df3d22fbcc9b90b29336bd57c3130b06"
    sha256 sonoma:        "4b060d50cdb3875ae08ef1c5be54450c286e89f26a8ee7e84341a4188edde16f"
    sha256 arm64_linux:   "f475d82edf96dec27268f0b0d4e73a00f24005221d582bd1655fe0a680824200"
    sha256 x86_64_linux:  "0a04a713574597d825600a11a4d32b46d727655c8fdb0c4e00fe8ba309d5c77a"
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