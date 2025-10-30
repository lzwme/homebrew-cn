class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "8c2215ab2d54bdad531a7aea95308ccbf98348134f5cacc8a54b538bce0305d3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f8696d68874c770bb4fa97804f98271639084b223069c6a6ed95c94ce3ac9fc0"
    sha256                               arm64_sequoia: "f8696d68874c770bb4fa97804f98271639084b223069c6a6ed95c94ce3ac9fc0"
    sha256                               arm64_sonoma:  "f8696d68874c770bb4fa97804f98271639084b223069c6a6ed95c94ce3ac9fc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb4d088adb16cb6866b69d311b07e5599e1d5ae7aac4afca11edb1a5b819f7f6"
    sha256                               arm64_linux:   "1fb611926b70dadb715c51023bb3cf0de793216bc08c7c58aeec6b9fefa07777"
    sha256                               x86_64_linux:  "f29f5b04289c0946ad2f211d7fc634028326848e553a23c44069b731c7ff0322"
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