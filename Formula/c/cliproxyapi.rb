class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.30.tar.gz"
  sha256 "a48fdcea713a42efe5b974866142bb7051550d3a90802a2c7ee669854f439d5e"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "2699a0de8ec25e7e20b1e6b40b9550bdd3f1cd82ecdd385c7430496a20737fe3"
    sha256 arm64_tahoe:       "9870ef07d3bd1ce996134e26554b6156d08a2b95104528455e7d96d294cdf6c0"
    sha256 arm64_sequoia:     "e1906683128f02c9255e6af53dca798bbb8268671be51fc204eb5a80242d8576"
    sha256 arm64_linux:       "2bc2c519de842245b2db5125bf0c87edc88234258f0be8a083f3a484bc0e2dad"
    sha256 x86_64_linux:      "b70dfc5ee24ef6a46a5952428c37ca249272d2b8a60487b909758ed0cadbeab4"
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