class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.38.tar.gz"
  sha256 "631f9c05a6f035e73f50f160048c2e7b87e293c5e246c6e82b8780dd627bca52"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "186bdfc50ce194c71fed8d270ce577df69d65abdacd35a6b8ed6141c6be6be92"
    sha256                               arm64_sequoia: "186bdfc50ce194c71fed8d270ce577df69d65abdacd35a6b8ed6141c6be6be92"
    sha256                               arm64_sonoma:  "186bdfc50ce194c71fed8d270ce577df69d65abdacd35a6b8ed6141c6be6be92"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ac0e61102fd5fb0f0cbdec58242cad7f1c534ea1e47e04c739f586c83dffa4b"
    sha256                               arm64_linux:   "67e3c6b901d0ef59a8dbb0aa6c99e342f3e2a36fc2d289424dfa31c21fe9adec"
    sha256                               x86_64_linux:  "b51f39487497e662e3ab458e0ce90d933b06d7b14add198ea75d8f587796bf15"
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