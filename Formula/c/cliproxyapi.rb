class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.75.tar.gz"
  sha256 "3534766bff4f06006dac2d9bdae0cb92c1b8121d56cbbae166e528765ecfb795"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "06cdd4ed9fa1a5cafee9bb145c0d06abd725765fe74eb0f01125ec055d552228"
    sha256 arm64_sequoia: "f130002722127d43652fc4e71093c11ec384197685d06919b44c8d522b88d56a"
    sha256 arm64_sonoma:  "16655ec5dfcbcb7802fac83ab84b179e81a96e9ee13d519fa8fd58b1048b91e2"
    sha256 sonoma:        "ada6a64d180516e310323522e90ee95d38624496a0f20ca23c6acc0daa0cb091"
    sha256 arm64_linux:   "f6f32bf1608353005caf1ceb78e7ebe5de6020e3f8fb61bcf79e316d59da5077"
    sha256 x86_64_linux:  "b5e8de3433a3b16409f6442dc3e02bfffe3175b84d5ca25966e23ffac5fe597c"
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