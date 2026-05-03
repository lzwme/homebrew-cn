class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.10.0.tar.gz"
  sha256 "a4041d6285b95aeecbdcbd6668086b75ac0a465f27952f60b211031d0fca4592"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "d585b963424364b5e532a9a3db24ae9b07cd7fa58e33da0c4297d8c43004550b"
    sha256 arm64_sequoia: "d585b963424364b5e532a9a3db24ae9b07cd7fa58e33da0c4297d8c43004550b"
    sha256 arm64_sonoma:  "d585b963424364b5e532a9a3db24ae9b07cd7fa58e33da0c4297d8c43004550b"
    sha256 sonoma:        "2ef32c81b8138fd642d73cfb99c4c7c3ae69fa225b7166c899023f90432d1e32"
    sha256 arm64_linux:   "e2f383866eba13e8c7fe5310b15a673552afd00a160b8c74164927d11534b08a"
    sha256 x86_64_linux:  "c7eabf60966c00e4ba97fd2a1cd1ee6ee7c1e87a2f8a267a43c63ad98eec9e0f"
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