class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.25.tar.gz"
  sha256 "1fee67eb98a112c51aa0fb19cf7342b5ae1caa3ee5a78f65ed6f41a21ee7b67b"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "e8c3f233e5060e71f0acd24c6b56882538edc514baa36f34de3bf5ebd656b240"
    sha256 arm64_sequoia: "e8c3f233e5060e71f0acd24c6b56882538edc514baa36f34de3bf5ebd656b240"
    sha256 arm64_sonoma:  "e8c3f233e5060e71f0acd24c6b56882538edc514baa36f34de3bf5ebd656b240"
    sha256 sonoma:        "50109ea24fe89a05f32ecbf351b50e1884c35da6edd89d6cea85dea7bb5cded2"
    sha256 arm64_linux:   "35f658cbd9ac52c4e37b30297663cccd9f7996e987dfe5762db61f81f72deb05"
    sha256 x86_64_linux:  "5c12e91c164cd6f3a966d7b1e2b0eda70efa2b01fbe1d1bb1bcea33e2443f1cc"
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