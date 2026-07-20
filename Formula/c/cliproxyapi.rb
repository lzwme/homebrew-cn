class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.90.tar.gz"
  sha256 "e9cda56f3b8c91b0f9262ae427c21e512548041e24ace9e78d5e071d53429b6c"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "e2e238d9a1648296406a9011820d21982ec5aa9e690534ba0a989181fccba8e6"
    sha256 arm64_sequoia: "ff5d0579247d3d9c9d9796b875724c7f64029ac6d45acdd52b0c703ac0ac88db"
    sha256 arm64_sonoma:  "8971420e30fbd7832876a9f0bd21ee37ba6515aaf21923985d1f1f856289aab2"
    sha256 sonoma:        "f56c0654798bcee71f503e8cc1fabee70579a50c90a6b86080461266e0ed1aa4"
    sha256 arm64_linux:   "90630d478ac49bf5ef1a2e30d176a75d7931a8c649cfb0744d111793c1275bf3"
    sha256 x86_64_linux:  "3c36d2364e72d9336890d2e8c6ecbf57ac8a35e059db47def3d013e77b1404ef"
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