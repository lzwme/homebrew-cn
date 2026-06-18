class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.15.tar.gz"
  sha256 "81abb0275c8bb62f71d0f4401283bd671df977642935c7928727add1ed9f228b"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "b9a0bfdf08104f363b59a955d3ac3baa33edc5f42e299cf609456d9d59a6a409"
    sha256 arm64_sequoia: "756e0a5380dea2985d13a29484577b766dfffcb370adf46eb743737f48ac3675"
    sha256 arm64_sonoma:  "6d06b2fdf585696c733af640a72a763fcab193d9c53be433c3d4301e4ae3df6a"
    sha256 sonoma:        "54d4f9e41f971497e76f53b2d99f09e74dec5ae78630548a0e494a61518e8966"
    sha256 arm64_linux:   "1204d793b22d68b252e3ba3b65ff86512b93165cf9ea175639796ba6fcb232f2"
    sha256 x86_64_linux:  "5d2a6c203f8bb516133f5ec509b920e220eb756baa6bba606e16f4570ad6ccc1"
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