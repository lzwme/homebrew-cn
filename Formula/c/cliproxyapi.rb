class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.40.tar.gz"
  sha256 "8803265217a23bb0c7149d5f31c219245ed95d82405117f573d382a1c8b86bee"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "791bd8b771b898c1c6f6c003de6b9accac462ca8a94f894138400751cc15e3d6"
    sha256                               arm64_sequoia: "791bd8b771b898c1c6f6c003de6b9accac462ca8a94f894138400751cc15e3d6"
    sha256                               arm64_sonoma:  "791bd8b771b898c1c6f6c003de6b9accac462ca8a94f894138400751cc15e3d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f946387aac5574517e2e741d967b921eb00713146b9b6bd0b779bff54a77f295"
    sha256                               arm64_linux:   "ef76289c9f54d5174c89bce679963b78f8f3212c9c9c4ca2cad91165e39098a6"
    sha256                               x86_64_linux:  "8c737171b47f3c8b29a622e553dba0a8f899a820cf10e9d40726bec2683b0d18"
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