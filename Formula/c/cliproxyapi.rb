class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.10.tar.gz"
  sha256 "5ea7813be0c1c12265a1f459979045c6df6e09c4a73a3389a005701c1b2c2426"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "134b744a1f3cf6ebe702484f71b9a3faf447fdd7958822e9a013d2d1a4d22637"
    sha256 arm64_tahoe:       "2a10bd101235bbe46833b90a0e24d5e540248db1ba01978485256d4627176e87"
    sha256 arm64_sequoia:     "4ec6501a206fc0f914100c4023d3ecc92a2430f2465a630b8f34852cf6337e1f"
    sha256 arm64_linux:       "193a417999e3951687880b2e123f3b29f85d45045377f51c6972770a462f37db"
    sha256 x86_64_linux:      "cb89205079507b0d0e00d146188655246936e180373f9889b27e4b20f2d840cb"
  end

  depends_on "go" => :build

  # `test do` block needs local sockets for the login flow
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end