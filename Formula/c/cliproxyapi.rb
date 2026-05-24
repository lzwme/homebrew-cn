class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.20.tar.gz"
  sha256 "a248d278b30391052b24071a014757a7386e3e1c03e20bfc5b2b231263efec94"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "e84c1de4a4af3327d04942c468c9f4d2f5110fac7358a993f6464085146927a7"
    sha256 arm64_sequoia: "e84c1de4a4af3327d04942c468c9f4d2f5110fac7358a993f6464085146927a7"
    sha256 arm64_sonoma:  "e84c1de4a4af3327d04942c468c9f4d2f5110fac7358a993f6464085146927a7"
    sha256 sonoma:        "eff7c47c55a6539ea820e58932fd88c79f56851203cbe16b607edec27e3dea1f"
    sha256 arm64_linux:   "79856a40cc8d950fb7b3a4657a00f89f631aef3122ab4c5338e7389fd402967e"
    sha256 x86_64_linux:  "24e8be6028d53fc0bd6277f2e78f56d280355a93dfe411207735c0f9cd14212e"
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