class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.5.tar.gz"
  sha256 "0ecfad512519cdf546ef43b6d2e8712c5956ff746527943ce4e7ef0a49544aed"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "838ceb40c13ff4374e676b2db51300e9ce8aeea4ec3f6d918d8d37c135593eb0"
    sha256 arm64_sequoia: "838ceb40c13ff4374e676b2db51300e9ce8aeea4ec3f6d918d8d37c135593eb0"
    sha256 arm64_sonoma:  "838ceb40c13ff4374e676b2db51300e9ce8aeea4ec3f6d918d8d37c135593eb0"
    sha256 sonoma:        "2fac2c82a997af13abd0fe2eb70bb8cb2918abac49029dfe67af272b452079b4"
    sha256 arm64_linux:   "d227671971bbbb5b5795e9a3aa8293f68706ac549a9ba720f443349409259b92"
    sha256 x86_64_linux:  "533b1bfac901da87612220a9b39018b2b1caf4c961d5fa213ac5fa995f903f4e"
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