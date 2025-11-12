class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.34.tar.gz"
  sha256 "195cfc8bfb2ccf62a4a22e23b0cc8514c4c595b6306b4cb309b3719f2b8fa99c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "281bcffd839d7561151eff2141bcdf4d8c03313ff6cae809bfd39edb6d024b3c"
    sha256                               arm64_sequoia: "281bcffd839d7561151eff2141bcdf4d8c03313ff6cae809bfd39edb6d024b3c"
    sha256                               arm64_sonoma:  "281bcffd839d7561151eff2141bcdf4d8c03313ff6cae809bfd39edb6d024b3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "debb4905648a3c5c6fd1e2bd70accd1aebc59335729048ee68ca4b54235cf5ec"
    sha256                               arm64_linux:   "525a774db2e604dc6ab840bfc2848646e3e96f335ff50e699e6cc592e8443f6f"
    sha256                               x86_64_linux:  "d691aeab8a01cf91d838a9fec1ebcc959052fab63c1e5c32d8bd4867c4f94ccf"
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