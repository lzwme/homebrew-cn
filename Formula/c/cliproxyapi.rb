class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.70.tar.gz"
  sha256 "fac52fee2711f73cc40aae9858ec273d9ebf98c569a017d30eec18c9c9424210"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "0809d9a9f348f827e98bc46936cbbb67e4ae9de3d4a40666568ede394c5de24c"
    sha256 arm64_sequoia: "83b67800aaaab5cd61b699a6f99e552fafaf4a9340888f1652984b029572ce42"
    sha256 arm64_sonoma:  "3016969f41b46a6fb2c9afaa1375f34929e5cc874be225bd77746e13eee8ef58"
    sha256 sonoma:        "8156dfbc0967ffb55587cb4ef0e5371a6cdd0c350e9cb9cb3e80cb052890260a"
    sha256 arm64_linux:   "86d3d95f8cb566b59beb747637e480df5d37cdac96d61f07f4cf6166e520264d"
    sha256 x86_64_linux:  "71d0093eef6d227bd7e46e82c9a038aec5a4daa7693f5f2bc1af7a484df7a43e"
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