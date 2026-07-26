class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.100.tar.gz"
  sha256 "9d6f6b884c0761254170b7c1f6d73ee0630a4beaaa9914b02e9b9f912d216a44"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "daab19f8a3402e2b42dd3f4aa91c2083f8044a464fef7d4c7b5af68deb79bf81"
    sha256 arm64_sequoia: "cd1f1b85b03f94adae16f8d16febde7205c98e416bee9850a0597009ff25b3a6"
    sha256 arm64_sonoma:  "6473f87cab4ca848cf0d31da05b2cada2c0e17763194eee0049bab8e93bec5ee"
    sha256 sonoma:        "b4dc48286d07d9f649b6cd5ceeddda2e7588fc9e657c862fb37b89265e2f6f99"
    sha256 arm64_linux:   "f47350ad43b1eab6b82ae435ab33767d0c64e9e6a10852d64868f4934235e9f4"
    sha256 x86_64_linux:  "8eaf5d477827f09ceca16a97a443993584cdfdea2e1f14e85ad28366a1f22b6f"
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
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end