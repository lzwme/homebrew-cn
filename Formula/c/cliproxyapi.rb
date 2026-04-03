class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.9.10.tar.gz"
  sha256 "677acd2fe486c291960732916bb183127fe9ecc7283f0d9d1bd540693c27b3e2"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "309641cfb9549b64b421a050c6e51bb0f30dfa78d5956702acf2274702f198e0"
    sha256 arm64_sequoia: "309641cfb9549b64b421a050c6e51bb0f30dfa78d5956702acf2274702f198e0"
    sha256 arm64_sonoma:  "309641cfb9549b64b421a050c6e51bb0f30dfa78d5956702acf2274702f198e0"
    sha256 sonoma:        "0fe9077856d8d75caa8e2f0b64b6fd076d035f1565b149086f19b52597831ccb"
    sha256 arm64_linux:   "0f74e56dde8c8c8347d1be88f3d30028208ab9c7d157a26d7f7edc69abcdf551"
    sha256 x86_64_linux:  "f59ca364ebc8431ea747a04f04d752272f1dc65e53ac2d856102ec160e15e6aa"
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