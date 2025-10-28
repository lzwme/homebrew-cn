class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.35.tar.gz"
  sha256 "635eea6e09618ae0b6320dbc1168db691bcbbedbf1c9196e64cb4da491ce164a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "08157f0341308c41c7bafe31ad1fb3b2798def6ce09fb095e47cd478f6fc03e5"
    sha256                               arm64_sequoia: "08157f0341308c41c7bafe31ad1fb3b2798def6ce09fb095e47cd478f6fc03e5"
    sha256                               arm64_sonoma:  "08157f0341308c41c7bafe31ad1fb3b2798def6ce09fb095e47cd478f6fc03e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2ec2e4bebeff5646678f911408ee4e8bb72695dd330c369d4810efe14ad2e9a"
    sha256                               arm64_linux:   "ee3091be408a743a55fed57e0da50ef3517e22c1a763fd7205ddab0774b6936b"
    sha256                               x86_64_linux:  "fcd98dffcdfe32b4a423b8c7e181cb924f91409ee84421b4a96ae5321c47762a"
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