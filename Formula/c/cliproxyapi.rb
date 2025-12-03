class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.35.tar.gz"
  sha256 "011d4447a4dbb56dd4d57e41501eee8acdb295a082e64e4cb8378aeb3b1fb55b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "471330a4d6f0e2829f561a1c3bf10a4a2596cfd4a01998be25ff8f559e2b86e8"
    sha256                               arm64_sequoia: "471330a4d6f0e2829f561a1c3bf10a4a2596cfd4a01998be25ff8f559e2b86e8"
    sha256                               arm64_sonoma:  "471330a4d6f0e2829f561a1c3bf10a4a2596cfd4a01998be25ff8f559e2b86e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2db893a1e4f9632288d6c1136fa8fa1f841a1d7bacf7e61a95a1e8b56492c3f6"
    sha256                               arm64_linux:   "102b03ea698090d51fba494900335d5e6224e74be334896180e7c07174506e4a"
    sha256                               x86_64_linux:  "44499c5828cae353020da1e1448a57f7114e43e36051f1da845ee97d76a2d794"
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