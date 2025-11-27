class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.24.tar.gz"
  sha256 "df4afdef4b186026104f5eef00611c33914d8b22645c1c1a3c7478c305b346a8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "49a953fe4079cc82c35f5e62e91b477f10c7d347f927f8c4914ddd980b0173d1"
    sha256                               arm64_sequoia: "49a953fe4079cc82c35f5e62e91b477f10c7d347f927f8c4914ddd980b0173d1"
    sha256                               arm64_sonoma:  "49a953fe4079cc82c35f5e62e91b477f10c7d347f927f8c4914ddd980b0173d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dd0da5c32b8cd78379771657772fdff6bcbbe57180f37fbd58f9a124c6819d4"
    sha256                               arm64_linux:   "ef1d4d5201ab983731888bd531dc4f252770785f290a65154920ec00c1c5a3e6"
    sha256                               x86_64_linux:  "f12b832e44089f703e05d5e1ff2430be01df5b69f4bce7ac1d0c36db64f0dd1c"
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