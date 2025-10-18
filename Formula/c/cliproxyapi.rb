class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.20.tar.gz"
  sha256 "f544043cafd5580db258659453941a947ce05e75127d8118d0b53dbe05b9e390"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "de77a01d61e738a57b4f8d7b71e8c2d40b09a47550d5220c46b2a82357d7925e"
    sha256                               arm64_sequoia: "de77a01d61e738a57b4f8d7b71e8c2d40b09a47550d5220c46b2a82357d7925e"
    sha256                               arm64_sonoma:  "de77a01d61e738a57b4f8d7b71e8c2d40b09a47550d5220c46b2a82357d7925e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b86ec3bfbb13f47da3f2509fd4ac376c60fe8202adf47feec9df571482d218c2"
    sha256                               arm64_linux:   "2366b538a43749addb2ae9c6b2c577b9e1d6b70cbe557fdbb37d6d2dd2df7d53"
    sha256                               x86_64_linux:  "6ac5b1ee5356be02f3007432a608ad6012c5011cce9be6dd6c67f11495182579"
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