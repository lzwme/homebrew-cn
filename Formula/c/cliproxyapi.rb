class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.48.tar.gz"
  sha256 "64f1311404412dd93ec4dda8bf6654ddc7a5158714a9a30ee9b1fa20364b7418"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b2427944424ffe2df29951e5a4c97c1a8bab69d636f88a06dd8aa63fe3c5c185"
    sha256                               arm64_sequoia: "b2427944424ffe2df29951e5a4c97c1a8bab69d636f88a06dd8aa63fe3c5c185"
    sha256                               arm64_sonoma:  "b2427944424ffe2df29951e5a4c97c1a8bab69d636f88a06dd8aa63fe3c5c185"
    sha256 cellar: :any_skip_relocation, sonoma:        "c951bb7f18e1080c22b17613d711428ed8454ee3b8cdb5c45be34a11ff1c71c8"
    sha256                               arm64_linux:   "c0e97668607e97cb0c3b407c6145326dbe7149e04237cc138720b08c2d22a0f4"
    sha256                               x86_64_linux:  "9d2c5035c6c7ffc3fd1866dd6e4f703116c3042923f56a21bbb3b12b29c7754f"
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