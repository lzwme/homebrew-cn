class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.85.tar.gz"
  sha256 "18e5a781647d2130442fa5f5d0326b0be07be30abc5dd6ffe54a4b902c8c329c"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "2343dd4416d9128c3aebae8118556c47f4b8d05ecbe7f4c97f063889e0f03073"
    sha256                               arm64_sequoia: "2343dd4416d9128c3aebae8118556c47f4b8d05ecbe7f4c97f063889e0f03073"
    sha256                               arm64_sonoma:  "2343dd4416d9128c3aebae8118556c47f4b8d05ecbe7f4c97f063889e0f03073"
    sha256 cellar: :any_skip_relocation, sonoma:        "c09f2a80cebf7880f359d4f323d835af193b4e87e7b640daf042d46ef78f00df"
    sha256                               arm64_linux:   "215de18c21337de092d75e6b82ea0b62e81d5c5beb14da97aa9ad416d9c52876"
    sha256                               x86_64_linux:  "7f2d9bd1954eeac6e466a316743cffa7e08bc0e21c4c78e23372bdab7f2ce83c"
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