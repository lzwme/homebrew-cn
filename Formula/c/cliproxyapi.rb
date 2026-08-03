class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.115.tar.gz"
  sha256 "8ab4130d6335448d710b04cca5b7ce66ad1b88cdb480728722fe5f80a6ef0bd8"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "717ff2ef67bc9e3928be727b4458c7f9c8310c184ad44bc6137c9c9af4094a3d"
    sha256 arm64_sequoia: "ff0c4dbf6349869a6ad185267775575d06c9e15bb2b9abda92adf1fe801e50f2"
    sha256 arm64_sonoma:  "1994831537a74a727032d26590a3ed3e8bd2e6b36758aac2d060035c0f0c5062"
    sha256 sonoma:        "384ea21c37f033f2f356e4d9122e8f96976649920c72983729f74b0f8b6270fb"
    sha256 arm64_linux:   "dbcf21eb1408b5f20ed4a797c12c31b324890024934afddabb8b8ad95b6d1471"
    sha256 x86_64_linux:  "34eb9e18605b01af3df15724ed1fb0236568a08a9ac7be5fadd51b7fa1c0578f"
  end

  depends_on "go" => :build

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