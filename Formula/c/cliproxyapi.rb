class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.5.tar.gz"
  sha256 "0b314a5f36167c95740604e45823445c93bab402ecaf6bdc013031a9601a1a16"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "e7109b646f80f8af47d4ffb3aed5727651950c0510de46e8e3555c0e431ab3b4"
    sha256                               arm64_sequoia: "e7109b646f80f8af47d4ffb3aed5727651950c0510de46e8e3555c0e431ab3b4"
    sha256                               arm64_sonoma:  "e7109b646f80f8af47d4ffb3aed5727651950c0510de46e8e3555c0e431ab3b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7dd15f4246e95706d23439ed97a76012816a035101231937c47620e974c1f6e"
    sha256                               arm64_linux:   "bae7b7515d480fc8e15a7dca8d03277f5d1ec0ea6f0e31098bdc4bec89d1f9f3"
    sha256                               x86_64_linux:  "7f0455db8d5227e55595346d427bedfaf5650322cb1a411e6ba32614eba045bd"
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