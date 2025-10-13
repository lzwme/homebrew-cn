class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.5.tar.gz"
  sha256 "67951b2aa6e1636ae6f0641ddf5d7b9304da9ff3f4887320949fc5b92da9a86b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "eb48eff2fa1f594f923670921db33fb382181c043f543c952509925192e5a831"
    sha256                               arm64_sequoia: "eb48eff2fa1f594f923670921db33fb382181c043f543c952509925192e5a831"
    sha256                               arm64_sonoma:  "eb48eff2fa1f594f923670921db33fb382181c043f543c952509925192e5a831"
    sha256 cellar: :any_skip_relocation, sonoma:        "baf990d3e14c6f451df657d6cd2f8c9ddee731fddd17e9ae94304a771533f5de"
    sha256                               arm64_linux:   "60b12265cb9354dd6f3e323f765cea2ea61e02a6c05aa168d070ccee0aaceb5f"
    sha256                               x86_64_linux:  "eea855d405b11af2dabf692f39b27ca6f17f76597ded25348ee9009045fada84"
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