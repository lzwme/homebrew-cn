class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.60.tar.gz"
  sha256 "83cbec9eed437d25000b577714d493f6faff250bd3d3c9f0228948b2abd2858f"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "973c5d62b036bda56b2dc8bc9ab37c028d58594be6ac02f5be7f84b24f79352e"
    sha256                               arm64_sequoia: "973c5d62b036bda56b2dc8bc9ab37c028d58594be6ac02f5be7f84b24f79352e"
    sha256                               arm64_sonoma:  "973c5d62b036bda56b2dc8bc9ab37c028d58594be6ac02f5be7f84b24f79352e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f92e4fd568e7c6fff1744310453605f1190daf1c68d5c8f91e20ab0dac7d4e94"
    sha256                               arm64_linux:   "3e1719d30969ee643a746596969abbb79fb1574201f1d88b80c4610559adea97"
    sha256                               x86_64_linux:  "104e64078f3ce932369f11b8ed9a7044ba2982794e0fba7c5936b8610c6b37cb"
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