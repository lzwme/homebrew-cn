class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "9bf7bc2185974e683fcac0fb17b5ca1faaceb5a00a9eb0450b67e3e619709638"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "63f6739f848e21a469ecbe6f91b8fe722573078fc3e8e8bbfc2a8ded699735a6"
    sha256 arm64_tahoe:       "d2a9d5f7aacc7097e2733f7089cdfd79b427ea9ec307b72914ee66938638fd25"
    sha256 arm64_sequoia:     "356045155ef27e270bf6ebd09ee7b5fd2539ac864d9fdbb7fc4bf0979f992d43"
    sha256 arm64_linux:       "6d722a7730eb36ff2878600f4b4d7356bc8ffd6c3ae95b478676e29a6188ff5f"
    sha256 x86_64_linux:      "e60001f6367772e396a251c1a853005b61c8cd8380e07bba677f6fe31cc83de1"
  end

  depends_on "go" => :build

  # `test do` block needs local sockets for the login flow
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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