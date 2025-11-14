class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.39.tar.gz"
  sha256 "b007dcbca212d7304ce1b0a1d7dae575875be997b07a2639512ab99012516b6f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "77d70f201d1f4322c78af6f1a68fc77428c9fcae6c2cd242c4fdab112ea82cbc"
    sha256                               arm64_sequoia: "77d70f201d1f4322c78af6f1a68fc77428c9fcae6c2cd242c4fdab112ea82cbc"
    sha256                               arm64_sonoma:  "77d70f201d1f4322c78af6f1a68fc77428c9fcae6c2cd242c4fdab112ea82cbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "239bd2aae47ef18ee209673887b07080d07413b58b6eb3e2ccc120533c96f2e7"
    sha256                               arm64_linux:   "cd5a692a159da03656cc02ae516af759bf1781cd75c6804faf9a078f36c3d71f"
    sha256                               x86_64_linux:  "80a6375322843b9782fd0e008a1d59d380fa3b10763a623e69ccc128f5253c0b"
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