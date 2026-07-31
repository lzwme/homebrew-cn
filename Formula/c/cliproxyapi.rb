class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.110.tar.gz"
  sha256 "2566c61b3686d50e979235933e7a9fa0529bfd1e1f965bdedb8d11265002ecea"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "9185d357f6a00b3e5c82b190784b4425074b24af92e8e6c377343bb44248ee0e"
    sha256 arm64_sequoia: "c31553c281fa9ea5aa3182224ac294dca6682e811cfebb2fc002cce232813279"
    sha256 arm64_sonoma:  "d686b7845d6b3971795398001882a89508afed0769ead4fbbf76c8b97cbc1eaf"
    sha256 sonoma:        "ff54058a208a8e3f1455d914c93dccdd2f49b2effb09fbb58a8334852650bef6"
    sha256 arm64_linux:   "a338216b0e0804d67d8bb717a7cb31fe09e09790e461923dc494cad5ed5404b7"
    sha256 x86_64_linux:  "0af7d1c69646d0facee3a0e796bb1f9a6aa9c980bcc6f010d1731a7da6d5545e"
  end

  depends_on "go" => :build

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