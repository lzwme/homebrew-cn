class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.40.tar.gz"
  sha256 "d0cc8ac0edaf4d9da84078fa397bf22ef3593559ec48c79ce203fc20e0874d2c"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "fd71d5dfe8e13b92fb48ce3fb5829bbeda69edd38c215f5755e8fdbe36318a54"
    sha256 arm64_tahoe:       "d2255f0269a43603e824e5c87896446a41f9af6e30dc9dfb5512940e0966d21f"
    sha256 arm64_sequoia:     "03686ae612089c3556d4bdcb7e01b4b9526c7bf4f5e584a7f315eb89ab1dd361"
    sha256 arm64_linux:       "dd6e34e51114a27c8de38b5b913fd0bfd604f3bc03934225fa45193b1b58e55b"
    sha256 x86_64_linux:      "17fbf62709eb9ae244d8992d458a42f63d8e35095e60eb6a206da079d17b84f0"
  end

  depends_on "go" => :build

  # `test do` block needs local sockets for the login flow
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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