class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.70.tar.gz"
  sha256 "71f1f3a313ec03eb5bb77f2a015513618330821be5398c7695923f8aaf37d05c"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "0eda9c6dfb8de6797d037ce613ce73efc63c240a0961bf915ecdbdf89b90e8f0"
    sha256 arm64_sequoia: "36c6f1d541eff010c1c2788733b972666d45a3e0322b9c9000794df811f98c96"
    sha256 arm64_sonoma:  "94cfd9bb0990177914d5335fb0f6ad3dda441496f38d2d12c5d1c7a3a0698a8f"
    sha256 sonoma:        "5ca4f017aa15b8f5d70cff3cc2538fb815c87062f2a4fa184f8f9306b909fef2"
    sha256 arm64_linux:   "7ebc226458a9d4158d3db6a10b6510df9c935fdce5d3bce754aee1fbc0b2bbeb"
    sha256 x86_64_linux:  "bf4340143e49f532b1ccd5cc3193b1e0828d190ac5a8d373599c8a0511d44efe"
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