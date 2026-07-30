class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.105.tar.gz"
  sha256 "9972349f5836d95e5ed3cc3f721602ced797726c718b2ae84d1694ae04c12683"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "9882f0070afe731b204a4c0db8d75f30aae1812c41de68abd959219d5dc3f4de"
    sha256 arm64_sequoia: "53fc8ce0566b78cbc36cef929f7862067aff684d6814baa965dcfde7c3111e4e"
    sha256 arm64_sonoma:  "89e40617d3baf2b3ee746df9af88e7a49459203f32672ce6c3f0b0c9fb722643"
    sha256 sonoma:        "2fb2d6b992e800e6395c18a9c984d45afc36fc99513b8e9bcf4f81cc2d5045de"
    sha256 arm64_linux:   "aab8b1e2825455cc619eaf6f1f4ed4c5cfeb79047bc7c39b2b6314505727fd10"
    sha256 x86_64_linux:  "0ca4d4e5546d5c227b11cbe4ea15fba7d0ad78e095d11eee5681f4ca82e3e039"
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