class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.155.tar.gz"
  sha256 "217e8d72443918fba750e833a0c6f143f6b689df7f9bfda5afda84f1ad59d041"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "2f7e28983a1010aa5631213acf0ec64e1d6e1f51b76450d14ae8946aa86d04cb"
    sha256 arm64_sequoia: "996159710458fcf1a3c000036f818982da3f6ea6db1a9de77fe257c8fd2566b8"
    sha256 arm64_sonoma:  "cc32e92a14502c0560c1de2c1366f0fa0f593cca1d674f8feb49f0b8c777b066"
    sha256 arm64_linux:   "0065ddb14e431d454d12253e318226b9fbf06deceb08e510d0c14ea88352880d"
    sha256 x86_64_linux:  "79175cdbd99122c318841e9448d15c574672a489aba87c717c650b8516534775"
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