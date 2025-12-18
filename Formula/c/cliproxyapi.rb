class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.25.tar.gz"
  sha256 "99517a359418c8f03e11330a4e06d194134c64dbd79d02667cffc00fbd56800d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f9007a79878dc02c2d10db748154ce33e4538ddc033f024d526cf430fde7df55"
    sha256                               arm64_sequoia: "f9007a79878dc02c2d10db748154ce33e4538ddc033f024d526cf430fde7df55"
    sha256                               arm64_sonoma:  "f9007a79878dc02c2d10db748154ce33e4538ddc033f024d526cf430fde7df55"
    sha256 cellar: :any_skip_relocation, sonoma:        "dec9618036c73fc934d5d6e9e6a1b3bb3aa3959d90a8ddd43e2cdcc804a9472d"
    sha256                               arm64_linux:   "3cae883f21f47f5631bd2a512903d407afe89a14f9502cfcf7d892375d1ee1fc"
    sha256                               x86_64_linux:  "adda8901f3ed925e73802bd2d49a0347c6ef56b6a98db7c980a77846d8ec4a57"
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