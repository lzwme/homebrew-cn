class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.10.tar.gz"
  sha256 "5fe9977bfaac22bba931f409b5cd2145c580593372e81f7e1c3e7e5108f54d46"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "8901e84709c47c2aa65c0713a9e9c822d29b779ebfb3489a9374ba9faf0c645d"
    sha256                               arm64_sequoia: "8901e84709c47c2aa65c0713a9e9c822d29b779ebfb3489a9374ba9faf0c645d"
    sha256                               arm64_sonoma:  "8901e84709c47c2aa65c0713a9e9c822d29b779ebfb3489a9374ba9faf0c645d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bf20f705f9f8087ba1e9ef0e64c13858f05c076a36ee07989ca97412c403d41"
    sha256                               arm64_linux:   "9caa27dfdecc36c1c06cf858ddf4c4c1200d777952e82f30437b7a38b9b1e1db"
    sha256                               x86_64_linux:  "577dd7e8e9c086b3fdf219cdfe5afd1c904a631558399d2890d381d846985f70"
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