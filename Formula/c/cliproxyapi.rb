class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://ghfast.top/https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.49.tar.gz"
  sha256 "66bb11fe35fe2fdfd5d967272b343d3ee0a554b817c9e1fe2903bebafe423fca"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2a4a0833237dd78e1fe77d7133d0709b7da9761f81dd0f98ee0fb55a9fd20acb"
    sha256                               arm64_sequoia: "2a4a0833237dd78e1fe77d7133d0709b7da9761f81dd0f98ee0fb55a9fd20acb"
    sha256                               arm64_sonoma:  "2a4a0833237dd78e1fe77d7133d0709b7da9761f81dd0f98ee0fb55a9fd20acb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e7af678a47792c1149faf3be7df7c833ac774b7f04a77800f495958fbb01d91"
    sha256                               arm64_linux:   "1ad7fc1600cb0b26377f5e08176390813acf1feb514e61a53fc0c3ae53058ef5"
    sha256                               x86_64_linux:  "37f5ba8acfc4ac1a9f6c96f3da9191cee1f08ec391d50c7f0ebb0330ce4fb157"
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