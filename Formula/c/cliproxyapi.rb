class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.65.tar.gz"
  sha256 "3083a3f6393a69db8c48e75a92dac708d41dd5f87a614b0749429b24d344e954"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "b2519fbc67dbc70c3cbf267e52dca610e09b0ad29f441d047df929b8c50418f4"
    sha256                               arm64_sequoia: "b2519fbc67dbc70c3cbf267e52dca610e09b0ad29f441d047df929b8c50418f4"
    sha256                               arm64_sonoma:  "b2519fbc67dbc70c3cbf267e52dca610e09b0ad29f441d047df929b8c50418f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "42416faf2cc214b0d3df472226954fc732ae03462c337a8b1411c13f40198142"
    sha256                               arm64_linux:   "2d10c51aa25b9d92e093e8a2ca8b42ccd702a6fd342802c34f2797657a4fa57e"
    sha256                               x86_64_linux:  "c073b57fef628df3a9edf47fbca9120d961016741f22573e39c56cb587488a82"
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