class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.10.tar.gz"
  sha256 "2c8fdca03aac5fe21d8f4ad92ec71f1d9886665adf4fa43fdb124a5abbcd3828"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "9c146f53e2b622968f8830c5ff39cc2307b84f4e9c8fff54f45cf1b1af3d195d"
    sha256 arm64_sequoia: "9c146f53e2b622968f8830c5ff39cc2307b84f4e9c8fff54f45cf1b1af3d195d"
    sha256 arm64_sonoma:  "9c146f53e2b622968f8830c5ff39cc2307b84f4e9c8fff54f45cf1b1af3d195d"
    sha256 sonoma:        "02e42398a38f4c887717d1bd72ec7c8ccd203240593af78cfbd3308a991d744f"
    sha256 arm64_linux:   "729d227c543f20e8c387ba2a62d5ae5583a0c66c8edb9e2a7e150b784a071342"
    sha256 x86_64_linux:  "76ce7c3e011f385a5d666aeda9e484defb4a5df6acff44303ebfddf5107d177a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?
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