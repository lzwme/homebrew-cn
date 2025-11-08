class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.16.tar.gz"
  sha256 "114ced39de43f0255b4e2d80c8e0f13647aae8f9a0f9ad04b7cd3ff8ecfe325a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b67fa6014f079d1de37734baa89451dc483e442f1568f2a83b6b295734ee74ee"
    sha256                               arm64_sequoia: "b67fa6014f079d1de37734baa89451dc483e442f1568f2a83b6b295734ee74ee"
    sha256                               arm64_sonoma:  "b67fa6014f079d1de37734baa89451dc483e442f1568f2a83b6b295734ee74ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "accf53ed66a66e26c9ebf994757af91cd1bdbd0090fe3905f9e8c0e0cc754873"
    sha256                               arm64_linux:   "b2fdd437cc2202110e59536f1b9bbb4a5be5a44f5daf42dbb444d6d77e9beae8"
    sha256                               x86_64_linux:  "d437d363729f39122ffbbabbd40df284603c9c5138f3db405101520f080ecfe9"
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