class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.35.tar.gz"
  sha256 "9855de932c62fc19d1e1b4a6e4a0a29782e104f85d3aa9fe2034fb80c7f5d0e7"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "c4bd411b3040e6557fc19d3b6c00be76574ac21a011678ff7993b4be3792fefa"
    sha256 arm64_sequoia: "e1e3d1a356c5cf1b64e6afefdd45b30eb12be2227694a061890578c8607425ee"
    sha256 arm64_sonoma:  "900e3428b378c29f34aaf9fb1d7b30f27682a70ece76e40096d0c0729145a219"
    sha256 sonoma:        "a8489af4549ec1554dba2d3d772646c90a5155ea9e1ad7b9908794c28e5c4247"
    sha256 arm64_linux:   "38d4bf000164e2254f36d0bb3b87ad998eafca731cc67773e0429a5db7224555"
    sha256 x86_64_linux:  "c7ff796331a5545d53da8e0e2505f75d4bf5dbd96456768ec9c37c0e6db9e95f"
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
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end