class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.30.tar.gz"
  sha256 "776cf944aa631f47844ac6c0b832054a2cf1bb0b783b10a974e3489136a6b2af"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "4093568c6675fdbf515f6fa1207c6db2962266ecc61f0a62f7029687191cfade"
    sha256 arm64_sequoia: "4093568c6675fdbf515f6fa1207c6db2962266ecc61f0a62f7029687191cfade"
    sha256 arm64_sonoma:  "4093568c6675fdbf515f6fa1207c6db2962266ecc61f0a62f7029687191cfade"
    sha256 sonoma:        "01617865c5eb67bd43877516dafea7d4e1a382395656a5526f4d0d6f9e41856b"
    sha256 arm64_linux:   "ce5948ffa42b63dc774fec402fcad6bd961cea4e095b96da7e2ce4ab14ba4227"
    sha256 x86_64_linux:  "77dd80320f4a6be873bb67e2ad7d6145ecd7573d0002467535b2211b269dfa87"
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