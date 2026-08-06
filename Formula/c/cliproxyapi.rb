class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.120.tar.gz"
  sha256 "42e53015a7d5d4983f8ce086891aa4deb2385bd254d162ada753cdadae615796"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "134c250c226db73107799c0002b5fa3871b793f3351db28a76ede0b97bdfe29d"
    sha256 arm64_sequoia: "5020d29f05c5123020bb88eb379a33d0e7109bb5a003e7d559675c8b8b92a7e9"
    sha256 arm64_sonoma:  "021bb36b5b802e0454b33d399ec989222c6d9c5f93435feb01f3c7f94533a837"
    sha256 sonoma:        "a6b1bb3600f0fb2905ae9446384a495b4e6ed5792d06f234c874d75a9c44a178"
    sha256 arm64_linux:   "f028bba7187011521c2703bf387a9ccf8a6656b984930fd6aba2d02adb068712"
    sha256 x86_64_linux:  "3d0188a577c37b470a8f5c3e1272d825e51e78799d892d5554cf86a249a7194b"
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