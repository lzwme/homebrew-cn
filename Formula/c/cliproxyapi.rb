class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.2.tar.gz"
  sha256 "8e06e01eba251c14e2fd070b1572d33e78ee3f65059dbe5f7b0492bce12c3cde"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b626777241a2cafd2206cc9f170df290540bd6161cb19cc2702e5e6d2032a3f2"
    sha256                               arm64_sequoia: "b626777241a2cafd2206cc9f170df290540bd6161cb19cc2702e5e6d2032a3f2"
    sha256                               arm64_sonoma:  "b626777241a2cafd2206cc9f170df290540bd6161cb19cc2702e5e6d2032a3f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "18066937f8d10c5c808c9cacfa65cbe2f3ecbefdf56253f5af04e836fe43a861"
    sha256                               arm64_linux:   "89b16d84b89386f9e034a468d28ab25742d8f69b8967cd9fa3fa639759d8169c"
    sha256                               x86_64_linux:  "08a500a83b2d5acc15e8e0339c3f235abf8f362078dec23eba7eb4117a10bf62"
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