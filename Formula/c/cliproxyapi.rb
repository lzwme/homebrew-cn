class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.65.tar.gz"
  sha256 "9573fcfb67721d194e673299046e1e713deee726b904479108b51f001cd76147"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "d451ef8ab43f7d105d30f3c0e6f5cb0ec30074d9a4b31f6e18f5f1679f2eaf12"
    sha256 arm64_sequoia: "1d0c9c0d2e4f706142805340e863673cbae975539408ca43035147c54829a929"
    sha256 arm64_sonoma:  "0c378bb48de0fe5e4583ab5b580584605b4d0c0b2b35a148fbbf6ceea58789a2"
    sha256 sonoma:        "f34a4445efa137c1ace895d607611b8b7d8526decf24ab09c975f976db7e47b6"
    sha256 arm64_linux:   "d6996eed2a7d2472e49fb19ecb25231b2ff7ad4dd8f39b29c831d6607a004050"
    sha256 x86_64_linux:  "5415ffbf48e5144c71107dae9a32096e65653accb233e037397e6db331451faf"
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