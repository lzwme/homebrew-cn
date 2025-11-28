class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.27.tar.gz"
  sha256 "debb7cdaad2c10448ba89f9fcb1e555a23f311955562dc9d76ce93d6fa5ef370"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "254e378e1c8652d6d2909068e546240cd2bfedf5cefa6d0c62361e3320bc3b82"
    sha256                               arm64_sequoia: "254e378e1c8652d6d2909068e546240cd2bfedf5cefa6d0c62361e3320bc3b82"
    sha256                               arm64_sonoma:  "254e378e1c8652d6d2909068e546240cd2bfedf5cefa6d0c62361e3320bc3b82"
    sha256 cellar: :any_skip_relocation, sonoma:        "be69aab977594c2975d32a13467383dae259d5a22bd94c5ffdf33244f3d52dcb"
    sha256                               arm64_linux:   "7d79686d6a9338891fe94a5f0fe632b52041e4eff2287e95a3fd40cf13a1eee6"
    sha256                               x86_64_linux:  "04ff565b78b2e0b0d39fd9fa7c61f056344b8ec47cf3760b040200188ba84915"
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